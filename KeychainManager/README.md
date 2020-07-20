# KeychainManager

This package use a clean arch to build ultimate solution for keychain manager.

## Instalation

Import this package with SPM, or you can buid by your self with xcodebuild.

## Utilization

Start importing module with following command.

```
import KeychainManaget
```

After import this module you can use, instanciation KeychainManger class with following code.

```
let keychainManager = KeychainManaget()
```

You must payattion in some  below notes before continue:

First:
- You can initialize KeychainManager with no given bundle, but this will make application assum the main bundle.

