# Linux-Mouse-Jiggler
This is a free mouse jiggler for all my WFH peeps
*****************************************************

# Mouse Jiggler for Ubuntu Linux

A lightweight app that keeps your screen awake by subtly moving the mouse every 30 seconds. Includes a simple one-click installer — no technical knowledge required.

---

## What It Does

Mouse Jiggler prevents your Ubuntu machine from:
- Locking the screen
- Going to sleep
- Activating the screensaver

It works by moving the mouse 1 pixel right, then 1 pixel back, every 30 seconds. The movement is invisible but enough to keep the system awake.

---

## Requirements

- Ubuntu Linux (tested on 20.04, 22.04, 24.04)
- Internet connection (for the initial install only)

---

## Installation

### Step 1: Copy the installer

Transfer the `install.sh` file to the Ubuntu machine using a USB drive, email, or file transfer.

### Step 2: Open a Terminal

Right-click on the desktop and select **"Open Terminal"**, or press `Ctrl + Alt + T`.

### Step 3: Run the installer

Navigate to where you saved `install.sh` and run:

```bash
bash install.sh
```

If the file is on your Desktop:

```bash
bash ~/Desktop/install.sh
```

### Step 4: Enter your password

The installer will ask for your password to install required packages. Type your password (it won't show on screen) and press Enter.

### Step 5: Done

The installer will finish in under a minute. You'll see a **"Mouse Jiggler"** icon on your Desktop.

---

## How to Use

1. **Double-click** the "Mouse Jiggler" icon on your Desktop
2. Click **ON** to keep your screen awake
3. Click **OFF** to stop
4. Close the window to stop and exit

You can also find it in your **Applications menu** by searching "Mouse Jiggler".

---

## Uninstalling

Open a Terminal and run:

```bash
bash ~/.local/share/mouse-jiggler/uninstall.sh
```

This removes the app, the desktop shortcut, and the menu entry.

---

## Troubleshooting

| Problem | Solution |
|---|---|
| Desktop icon shows "Untrusted" | Right-click the icon and select **"Allow Launching"** |
| Status shows "ERROR" | Run `sudo apt install xdotool` in a Terminal |
| Nothing happens when double-clicking | Open a Terminal and run: `python3 ~/.local/share/mouse-jiggler/mouse_jiggler.py` |
| Installer fails | Make sure you have an internet connection and try again |
