# fish-conda-virtualenv
conda add-in that permits to activate/deactivate virtualenvs from a fish shell

## Requirements
- conda
- fish shell

## Install instructions
From the fish shell cd to this project dir, then type
```
>> fish conda-env.fish install
```

## Usage
Now from a fish shell you can activate a conda virtual environment with the command
```
>> source (activate) <conda-env>
```
and deactivate it with
```
>> source (deactivate)
```

