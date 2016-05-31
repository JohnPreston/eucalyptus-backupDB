eucalyptus-backupDB
===================

Role to backup the CLC DB to different targets

Requirements
------------

Must run on the CLC and the CLC must be able to remote copy the folders
You also must have enough space to store all dumps
You must specifiy the remote_user for the CLC to copy to remote (don't use root .. ?)

WARNING - this is pretty IO and CPU intensive on the CLC.

Role Variables
--------------

remote_user


Example Playbook
----------------

```

- hosts:
  - clc
  roles:
  - eucalyptus-backupDB

```

License
-------

GPLv3

Author Information
------------------

John Preston [JMille]

