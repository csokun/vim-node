# vim-node

## Usage

```bash
#!/bin/bash
docker run --rm -it -v $PWD:/src --network host csokun/vim-node
```

Add to your `bash` alias:

```bash
echo "alias js='docker run --rm -it --user $UID -v $PWD:/src --network host csokun/vim-node'" >> ~/.bashrc
source ~/.bashrc
```