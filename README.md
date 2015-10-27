# designax

## pre-commit setup
```
$ bundle install
```

## deploy development

### prerequisite

- needs to setup https access

```
$ mkdir -p /opt/app/designax/releases
REVISION=<RevisionTag> cap development deploy
```
## deploy production
```
REVISION=<RevisionTag> cap production deploy
```
