#!/bin/bash
# ============================================================================
#  Mouse Jiggler - One-Click Installer for Ubuntu
#  Just run:   bash install.sh
# ============================================================================

set -e

APP_NAME="Mouse Jiggler"
INSTALL_DIR="$HOME/.local/share/mouse-jiggler"
BIN_PATH="$INSTALL_DIR/mouse_jiggler.py"
DESKTOP_FILE="$HOME/Desktop/MouseJiggler.desktop"
APPS_DESKTOP="$HOME/.local/share/applications/MouseJiggler.desktop"

# ── Colours for terminal output ──────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No colour

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Mouse Jiggler Installer${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# ── Step 1: Install system dependencies ──────────────────────────────────────
echo -e "${YELLOW}[1/5]${NC} Installing required packages (may ask for your password)..."
sudo apt-get update -qq
sudo apt-get install -y -qq xdotool python3 python3-tk > /dev/null 2>&1
echo -e "       ${GREEN}Done.${NC}"

# ── Step 2: Create install directory ─────────────────────────────────────────
echo -e "${YELLOW}[2/5]${NC} Creating application folder..."
mkdir -p "$INSTALL_DIR"
echo -e "       ${GREEN}Done.${NC}"

# ── Step 3: Write the application ────────────────────────────────────────────
echo -e "${YELLOW}[3/5]${NC} Installing Mouse Jiggler application..."

cat > "$BIN_PATH" << 'PYTHON_SCRIPT'
#!/usr/bin/env python3
"""Mouse Jiggler - Prevents Linux Ubuntu from timing out / locking the screen."""

import subprocess
import tkinter as tk


class MouseJiggler:
    def __init__(self, root):
        self.root = root
        self.root.title("Mouse Jiggler")
        self.root.resizable(False, False)
        self.root.configure(bg="#2b2b2b")

        self.running = False
        self._timer = None
        self.interval = 30  # seconds between jiggles
        self.pixel_offset = 1

        # --- UI ---
        frame = tk.Frame(root, padx=30, pady=25, bg="#2b2b2b")
        frame.pack()

        title = tk.Label(
            frame,
            text="Mouse Jiggler",
            font=("sans-serif", 16, "bold"),
            fg="#ffffff",
            bg="#2b2b2b",
        )
        title.pack(pady=(0, 5))

        subtitle = tk.Label(
            frame,
            text="Keeps your screen awake",
            font=("sans-serif", 9),
            fg="#aaaaaa",
            bg="#2b2b2b",
        )
        subtitle.pack(pady=(0, 15))

        self.status_label = tk.Label(
            frame,
            text="OFF",
            font=("sans-serif", 22, "bold"),
            fg="#f44336",
            bg="#2b2b2b",
        )
        self.status_label.pack(pady=(0, 18))

        btn_frame = tk.Frame(frame, bg="#2b2b2b")
        btn_frame.pack()

        self.on_btn = tk.Button(
            btn_frame,
            text="ON",
            width=12,
            height=2,
            font=("sans-serif", 12, "bold"),
            bg="#4CAF50",
            fg="white",
            activebackground="#45a049",
            activeforeground="white",
            relief=tk.FLAT,
            cursor="hand2",
            command=self.start,
        )
        self.on_btn.pack(side=tk.LEFT, padx=8)

        self.off_btn = tk.Button(
            btn_frame,
            text="OFF",
            width=12,
            height=2,
            font=("sans-serif", 12, "bold"),
            bg="#555555",
            fg="#999999",
            activebackground="#da190b",
            activeforeground="white",
            relief=tk.FLAT,
            cursor="hand2",
            command=self.stop,
            state=tk.DISABLED,
        )
        self.off_btn.pack(side=tk.LEFT, padx=8)

        self.root.protocol("WM_DELETE_WINDOW", self._on_close)

        # Centre the window on screen
        self.root.update_idletasks()
        w = self.root.winfo_width()
        h = self.root.winfo_height()
        x = (self.root.winfo_screenwidth() // 2) - (w // 2)
        y = (self.root.winfo_screenheight() // 2) - (h // 2)
        self.root.geometry(f"+{x}+{y}")

    # --- Core logic ---

    def _jiggle(self):
        """Move the mouse by a tiny amount, then move it back."""
        if not self.running:
            return
        try:
            subprocess.run(
                ["xdotool", "mousemove_relative", "--", str(self.pixel_offset), "0"],
                check=True,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            subprocess.run(
                ["xdotool", "mousemove_relative", "--", str(-self.pixel_offset), "0"],
                check=True,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
        except FileNotFoundError:
            self.stop()
            self.status_label.config(text="ERROR", fg="orange")
            return

        self._timer = self.root.after(self.interval * 1000, self._jiggle)

    def start(self):
        if self.running:
            return
        self.running = True
        self.status_label.config(text="ON", fg="#4CAF50")
        self.on_btn.config(state=tk.DISABLED, bg="#2e7d32", fg="#88cc88")
        self.off_btn.config(state=tk.NORMAL, bg="#f44336", fg="white")
        self._jiggle()

    def stop(self):
        self.running = False
        if self._timer is not None:
            self.root.after_cancel(self._timer)
            self._timer = None
        self.status_label.config(text="OFF", fg="#f44336")
        self.on_btn.config(state=tk.NORMAL, bg="#4CAF50", fg="white")
        self.off_btn.config(state=tk.DISABLED, bg="#555555", fg="#999999")

    def _on_close(self):
        self.stop()
        self.root.destroy()


if __name__ == "__main__":
    root = tk.Tk()
    app = MouseJiggler(root)
    root.mainloop()
PYTHON_SCRIPT

chmod +x "$BIN_PATH"
echo -e "       ${GREEN}Done.${NC}"

# ── Step 4: Create desktop shortcut ──────────────────────────────────────────
echo -e "${YELLOW}[4/5]${NC} Creating desktop shortcut..."

mkdir -p "$HOME/Desktop"
mkdir -p "$(dirname "$APPS_DESKTOP")"

DESKTOP_CONTENT="[Desktop Entry]
Version=1.0
Type=Application
Name=Mouse Jiggler
Comment=Keeps your screen awake by jiggling the mouse
Exec=python3 ${BIN_PATH}
Icon=input-mouse
Terminal=false
Categories=Utility;
StartupNotify=false"

echo "$DESKTOP_CONTENT" > "$DESKTOP_FILE"
echo "$DESKTOP_CONTENT" > "$APPS_DESKTOP"

chmod +x "$DESKTOP_FILE"
chmod +x "$APPS_DESKTOP"

# Mark as trusted so Ubuntu doesn't show "Untrusted" warning
if command -v gio &> /dev/null; then
    gio set "$DESKTOP_FILE" "metadata::trusted" true 2>/dev/null || true
fi

echo -e "       ${GREEN}Done.${NC}"

# ── Step 5: Create uninstaller ───────────────────────────────────────────────
echo -e "${YELLOW}[5/5]${NC} Creating uninstaller..."

cat > "$INSTALL_DIR/uninstall.sh" << UNINSTALL
#!/bin/bash
echo ""
echo "Removing Mouse Jiggler..."
rm -f "$DESKTOP_FILE"
rm -f "$APPS_DESKTOP"
rm -rf "$INSTALL_DIR"
echo "Mouse Jiggler has been removed."
echo ""
UNINSTALL

chmod +x "$INSTALL_DIR/uninstall.sh"
echo -e "       ${GREEN}Done.${NC}"

# ── Finished ─────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "  How to use:"
echo "    - Double-click 'Mouse Jiggler' on your Desktop"
echo "    - Or find it in your Applications menu"
echo ""
echo "    Click ON  to keep your screen awake"
echo "    Click OFF to stop"
echo ""
echo "  To uninstall later, run:"
echo "    bash $INSTALL_DIR/uninstall.sh"
echo ""
echo -e "${GREEN}Enjoy!${NC}"
echo ""
