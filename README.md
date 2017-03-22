# renamer
Quickly add a new script to a workflow by automatically renumbering the existing scripts.

## Installation
`devtools::install_github("quartin/renamer")`

## Description
When files need to be run in sequence it is [good practice][1] to prefix them with numbers. This package makes it easier to add a script to the middle of an existing workflow without the need to manually renumber the all the scripts.

## Example

```
> library("renamer")
```
Start by adding a few workflow scripts...

```
> add_script("01-import_data.R")
> add_script("02-clean_data.R")
> add_script("03-explore_data.R")

```
![](examples/initial_workflow.png)

We now remember we need to add an initial configuration file...
```
> add_script("01-config.R")
Error in add_script("01-config.R") : 
  Script number in 01-config.R clashes with 01-import_data.R. Set renumber flag to TRUE to renumber scripts.
```
Since this can be a pretty drastic change, in case of conflict we need to set the `renumber` flag to `TRUE`:
```
> add_script("01-config.R", renumber = TRUE)
```
![](examples/new_workflow.png)


[1]: http://adv-r.had.co.nz/Style.html
