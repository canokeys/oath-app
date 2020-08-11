# Canokey Client

A Flutter Application,both support Android and IOS.This app is written for Canokey.

## Getting Started

This app is made for Canokey to do two-step verify.Support Google,Github,etc.The user introduction has
been written in app.

## Explanations to code

### Folders

#### DrawerPages：

AboutPage.dart:Use in main.dart.Show via drawer.

#### Images:

All the images sources are stored in this folder.

#### Models:

Bloc.dart&DataSave.dart&StreamBuilder.dart&MultiLanguage.dart:
These files are written for local storage,to store some users settings.And support-languages include:
**English,Chinese,Japanese,French,German**

**CredentialModule.dart :**
This is the most significant file.It contain all the functions to order Canokey.And it shows the credentials
on the screen.

LeftScrollPrefab.dart:
A Prefab which add credential module in CredentialModule.And it support user left scroll it to remove it.

StartPage.dart：
A lead in page.Use for beautify the app.

Tutorial.dart:
A instruction to lead users to use this app.Load at the first installation and the time user click 'help'.