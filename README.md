# Mouse Jiggler

Keeps your Ubuntu screen awake by gently moving the mouse in the background. Simple on/off buttons — no technical knowledge needed.

---

## How to Install

### Step 1: Copy the installer

Transfer the `install.sh` file to the Ubuntu machine (USB drive, email, etc.).

### Step 2: Open the Terminal

- Right-click anywhere on your Desktop
- Click **"Open Terminal"** (or press `Ctrl + Alt + T`)

### Step 3: Run the installer

If the file is on your Desktop:

```
bash ~/Desktop/install.sh
```

Or drag and drop the `install.sh` file into the terminal window, then press **Enter**.

### Step 4: Done!

You will see **"Installation Complete!"** in the terminal. You can close the terminal.

A **"Mouse Jiggler"** icon will now be on your Desktop.

---

## How to Use

1. **Double-click** the "Mouse Jiggler" icon on your Desktop
2. Click the green **ON** button to keep your screen awake
3. Click the red **OFF** button to stop
4. Close the window when you're done

That's it! While the program is ON, your screen will not lock or go to sleep.

---

## How to Uninstall

Open a terminal and run:

```
bash ~/.local/share/mouse-jiggler/uninstall.sh
```

This removes the program and the Desktop shortcut.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Installer says packages are missing | Ask your IT admin to run: `sudo apt-get install -y xdotool python3 python3-tk` |
| Desktop icon shows "Untrusted" | Right-click the icon, select "Allow Launching" |
| Double-clicking the icon does nothing | Right-click the icon, select "Allow Launching", then double-click again |
