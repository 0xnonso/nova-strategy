# <h1 align="center"> Nova Strategy </h1>

**How it Works**

This strategy allows nova relayers to return data from a call. 

Note: The nova protocol is in closed beta and is not yet publicy available so this software may or may not work.

[Nova docs](https://docs.rari.capital/nova/)

[Nova github repo](https://github.com/Rari-Capital/nova)

![Github Actions](https://github.com/0xNonso/nova-strategy/workflows/Tests/badge.svg)

## Building and testing

```sh
git clone https://github.com/0xNonso/nova-strategy
cd nova-strategy
make # This installs the project's dependencies.
make test
```



## Installing the toolkit

If you do not have DappTools already installed, you'll need to run the below
commands

### Install Nix

```sh
# User must be in sudoers
curl -L https://nixos.org/nix/install | sh

# Run this or login again to use Nix
. "$HOME/.nix-profile/etc/profile.d/nix.sh"
```

### Install DappTools

```sh
curl https://dapp.tools/install | sh
```

## DappTools Resources

* [DappTools](https://dapp.tools)
    * [Hevm Docs](https://github.com/dapphub/dapptools/blob/master/src/hevm/README.md)
    * [Dapp Docs](https://github.com/dapphub/dapptools/tree/master/src/dapp/README.md)
    * [Seth Docs](https://github.com/dapphub/dapptools/tree/master/src/seth/README.md)
* [DappTools Overview](https://www.youtube.com/watch?v=lPinWgaNceM)
* [Awesome-DappTools](https://github.com/rajivpo/awesome-dapptools)
