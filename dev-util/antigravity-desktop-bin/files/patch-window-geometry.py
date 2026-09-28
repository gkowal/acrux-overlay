#!/usr/bin/env python3
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

import json
import os
import struct
import sys

def patch_asar(asar_path):
    if not os.path.isfile(asar_path):
        sys.exit(f"Error: {asar_path} not found.")

    with open(asar_path, "rb") as f:
        buf = f.read(16)
        header_size = struct.unpack("<I", buf[12:16])[0]
        header = json.loads(f.read(header_size).decode("utf-8"))
        pad_len = (4 - (header_size % 4)) % 4
        base_offset = 16 + header_size + pad_len

        packed_files = {}
        def collect(node, path=""):
            for k, v in node.get("files", {}).items():
                curr = f"{path}/{k}" if path else k
                if "files" in v:
                    collect(v, curr)
                elif "offset" in v:
                    f.seek(base_offset + int(v["offset"]))
                    packed_files[curr] = f.read(int(v["size"]))
        collect(header)

    if "dist/utils.js" not in packed_files:
        sys.exit("Error: dist/utils.js not found in asar archive.")

    utils_code = packed_files["dist/utils.js"].decode("utf-8")

    if "windowBounds" in utils_code and "saveWindowStateSync" in utils_code:
        print("dist/utils.js is already patched for window geometry persistence.")
        return

    search_target1 = """    const win = new electron_1.BrowserWindow({
        width: 1400,
        height: 900,"""

    replacement1 = """    let windowBounds = { width: 1400, height: 900 };
    let isMaximized = false;
    const sPath = (storageManager && storageManager.storagePath) || (0, paths_1.getAppStoragePath)();
    if (sPath) {
        try {
            if (fs.existsSync(sPath)) {
                const raw = JSON.parse(fs.readFileSync(sPath, "utf-8"));
                if (raw.windowBounds) {
                    const parsed = JSON.parse(raw.windowBounds);
                    if (parsed.width >= 500 && parsed.height >= 400) {
                        windowBounds = parsed;
                    }
                }
                if (raw.windowMaximized === "true") {
                    isMaximized = true;
                }
            }
        } catch (e) {
            console.error("Error reading saved window bounds:", e);
        }
    }
    if (windowBounds.x !== undefined && windowBounds.y !== undefined) {
        const visible = electron_1.screen.getAllDisplays().some(display => {
            const { x, y, width, height } = display.bounds;
            return windowBounds.x >= x && windowBounds.x < x + width &&
                   windowBounds.y >= y && windowBounds.y < y + height;
        });
        if (!visible) {
            delete windowBounds.x;
            delete windowBounds.y;
        }
    }
    const win = new electron_1.BrowserWindow({
        ...windowBounds,"""

    if search_target1 not in utils_code:
        sys.exit("Error: Target window initialization code not found in dist/utils.js")
    utils_code = utils_code.replace(search_target1, replacement1, 1)

    search_target2 = """    (0, loadingOverlay_1.attachLoadingOverlay)(win, foregroundColor, backgroundColor);"""
    replacement2 = """    if (isMaximized) {
        win.maximize();
    }
    (0, loadingOverlay_1.attachLoadingOverlay)(win, foregroundColor, backgroundColor);"""

    if search_target2 not in utils_code:
        sys.exit("Error: Target overlay attachment code not found in dist/utils.js")
    utils_code = utils_code.replace(search_target2, replacement2, 1)

    search_target3 = """    // Zoom persistence — restore saved level and capture future changes.
    if (storageManager) {"""

    replacement3 = """    const saveWindowStateSync = () => {
        try {
            if (win.isDestroyed()) return;
            const isMax = win.isMaximized();
            const updates = { windowMaximized: String(isMax) };
            if (!isMax && !win.isMinimized()) {
                updates.windowBounds = JSON.stringify(win.getBounds());
            }
            const targetPath = (storageManager && storageManager.storagePath) || (0, paths_1.getAppStoragePath)();
            let existing = {};
            if (fs.existsSync(targetPath)) {
                try { existing = JSON.parse(fs.readFileSync(targetPath, "utf-8")); } catch (e) {}
            }
            Object.assign(existing, updates);
            fs.writeFileSync(targetPath, JSON.stringify(existing, null, 2), "utf-8");
        } catch (e) {
            console.error("Error saving window state:", e);
        }
    };
    let saveTimeout = null;
    const debouncedSave = () => {
        if (saveTimeout) clearTimeout(saveTimeout);
        saveTimeout = setTimeout(saveWindowStateSync, 250);
    };
    win.on("resize", debouncedSave);
    win.on("move", debouncedSave);
    win.on("close", () => {
        if (saveTimeout) clearTimeout(saveTimeout);
        saveWindowStateSync();
    });
    // Zoom persistence — restore saved level and capture future changes.
    if (storageManager) {"""

    if search_target3 not in utils_code:
        sys.exit("Error: Target storageManager block not found in dist/utils.js")
    utils_code = utils_code.replace(search_target3, replacement3, 1)

    packed_files["dist/utils.js"] = utils_code.encode("utf-8")

    # Repack asar
    new_files_data = bytearray()
    def update_header(node, path=""):
        for k, v in node.get("files", {}).items():
            curr = f"{path}/{k}" if path else k
            if "files" in v:
                update_header(v, curr)
            elif "offset" in v:
                data = packed_files[curr]
                offset = len(new_files_data)
                size = len(data)
                new_files_data.extend(data)
                v["offset"] = str(offset)
                v["size"] = size
    update_header(header)

    new_header_json = json.dumps(header, separators=(",", ":")).encode("utf-8")
    new_json_len = len(new_header_json)
    new_pad_len = (4 - (new_json_len % 4)) % 4
    new_aligned_len = new_json_len + new_pad_len

    new_header_buf = bytearray()
    new_header_buf.extend(struct.pack("<I", 4))
    new_header_buf.extend(struct.pack("<I", new_aligned_len + 8))
    new_header_buf.extend(struct.pack("<I", new_aligned_len + 4))
    new_header_buf.extend(struct.pack("<I", new_json_len))
    new_header_buf.extend(new_header_json)
    new_header_buf.extend(b"\x00" * new_pad_len)

    tmp_out = asar_path + ".tmp"
    with open(tmp_out, "wb") as f_out:
        f_out.write(new_header_buf)
        f_out.write(new_files_data)

    os.replace(tmp_out, asar_path)
    print(f"Successfully patched {asar_path} for window geometry persistence.")

if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "resources/app.asar"
    patch_asar(target)
