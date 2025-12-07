# DioCutter

###### Made because I can't read rust.

<!-- KONO DIO DA -->

## What is this?

This folder holds our iconcutter, which handles a subset of hypnagogic's toml system.

Most of the extra features we're missing are wallening-related, so we aren't going to be adopting them.

## How is it used?

The cutter works off 2 inputs. A file, typically a png, and a toml config file in the format `{filename}.{other input extension}.toml`

The input resource is transformed by the cutter following a set of rules set out in the .toml file.
Typically these are very basic. We have a set of templates in repo stored in [cutter_templates/](../../cutter_templates/) and most uses just copy from them.

You can find more information about it in hypnagogic's repository, found [here](https://github.com/actioninja/hypnagogic), the examples subfolder in particular contains fully detailed explanations of all the config values for the different types of cutting (there are more then one)

DioCutter only supports bitmask slice, and doesn't support animation, prefabs and map icons, though all these are planned to be supported.

We do however handle the positions block a little differently. Any unknown keys (anything that isn't the 4-5 expected values) are just added as additional icon states, mostly to keep code far more simple.

## How does it work?

Anytime you build the game, CBT will check and see if any of the files that the cutter cares about have been modified
If they have been, the cutter will perform a full runthrough, and compile all inputs down into typically dmis

These dmis can then be committed, and badabing badaboom we have autocut sprites.
