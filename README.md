# fish-conda-virtualenv
conda add-in that permits to activate/deactivate virtualenvs from a fish shell

## Requirements
- conda
- fish shell

## Install instructions
From the fish shell cd to this project dir, then type
```fish
>> fish conda-env.sh install
```

## Usage
Now from a fish shell you can activate a conda virtual environment with the command
```fish
>> source (activate) <conda-env>
```
and deactivate it with
```fish
>> source (deactivate) <conda-env>
```

