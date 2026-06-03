# GitHub upload commands

Use these commands inside your local `sql-practice` folder:

```cmd
copy C:\path	o\README.md README.md
mkdir database
mkdir docs
mkdir screenshots
```

Then copy the prepared files into the correct folders and run:

```cmd
git status
git add .
git commit -m "Add car workshop SQL database project"
git push
```

If this is the first commit and Git asks for your name/email:

```cmd
git config --global user.name "Zbigniew Łamaszewski"
git config --global user.email "lamaszewski.zl@gmail.com"
```
