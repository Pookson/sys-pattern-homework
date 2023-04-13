Домашнее задание к занятию 10.4 «Резервное копирование» - `Statsenko Nikolay`

### Задание 1

Полное резервное копирование (Full Backup) - это процесс создания резервной копии всей информации, которая находится на выбранных для резервного копирования устройствах. 
При полном резервном копировании вся информация копируется снова, даже если она уже была скопирована ранее. Поэтому это занимает больше времени и требует больше места для хранения копий.

Дифференциальное резервное копирование (Differential Backup) - это процесс создания резервной копии только измененных файлов с момента последнего полного резервного копирования. 
В результате, дифференциальное резервное копирование занимает меньше времени и места для хранения, чем полное резервное копирование. 
Однако, для восстановления информации из дифференциальной копии необходимо иметь и последнюю полную резервную копию, и все дифференциальные копии, созданные после нее.

Инкрементное резервное копирование (Incremental Backup) - это процесс создания резервной копии только измененных файлов с момента последнего полного или инкрементного резервного копирования. 
Инкрементное резервное копирование занимает меньше времени и места для хранения, чем полное и дифференциальное резервное копирование, так как в копию попадают только изменения. 
Однако для восстановления информации из инкрементной копии необходимо иметь все предыдущие полные и инкрементные копии, созданные после последнего полного резервного копирования.

### Задание 2

#### bacula-dir.conf
```
Director {                            # define myself
  Name = ubuntu-master-dir
  DIRport = 9101                # where we listen for UA connections
  QueryFile = "/etc/bacula/scripts/query.sql"
  WorkingDirectory = "/var/lib/bacula"
  PidDirectory = "/run/bacula"
  Maximum Concurrent Jobs = 20
  Password = "BjUJDlXWu5EqfkA3sk_OlZlK0eRXaYr2L"         # Console password
  Messages = Daemon
  DirAddress = 127.0.0.1
}

JobDefs {
  Name = "DefaultJob"
  Type = Backup
  Level = Incremental
  Client = ubuntu-master-fd
  FileSet = "Full Set"
  Schedule = "WeeklyCycle"
  Storage = File1
  Messages = Standard
  Pool = File
  SpoolAttributes = yes
  Priority = 10
  Write Bootstrap = "/var/lib/bacula/%c.bsr"
}

Job {
  Name = "BackupClient1"
  JobDefs = "DefaultJob"
}

Job {
  Name = "BackupCatalog"
  JobDefs = "DefaultJob"
  Level = Full
  FileSet="Catalog"
  Schedule = "WeeklyCycleAfterBackup"
  # This creates an ASCII copy of the catalog
  # Arguments to make_catalog_backup.pl are:
  #  make_catalog_backup.pl <catalog-name>
  RunBeforeJob = "/etc/bacula/scripts/make_catalog_backup.pl MyCatalog"
  # This deletes the copy of the catalog
  RunAfterJob  = "/etc/bacula/scripts/delete_catalog_backup"
  Write Bootstrap = "/var/lib/bacula/%n.bsr"
  Priority = 11                   # run after main backup
}

Job {
  Name = "RestoreFiles"
  Type = Restore
  Client=ubuntu-master-fd
  Storage = File1
  FileSet="Full Set"
  Pool = File
  Messages = Standard
  Where = /mybackup/restore
}

FileSet {
  Name = "Full Set"
  Include {
    Options {
      signature = MD5
    }
    File = /home/vagrant
  }

  Exclude {
    File = /var/lib/bacula
    File = /mybackup
    File = /proc
    File = /tmp
    File = /sys
    File = /.journal
    File = /.fsck
  }
}

Schedule {
  Name = "WeeklyCycle"
  Run = Full 1st sun at 23:05
  Run = Differential 2nd-5th sun at 23:05
  Run = Incremental mon-sat at 23:05
}

Schedule {
  Name = "WeeklyCycleAfterBackup"
  Run = Full sun-sat at 23:10
}

FileSet {
  Name = "Catalog"
  Include {
    Options {
      signature = MD5
    }
    File = "/var/lib/bacula/bacula.sql"
  }
}

Client {
  Name = ubuntu-master-fd
  Address = localhost
  FDPort = 9102
  Catalog = MyCatalog
  Password = "ysAs9Npquhu1FOLtdr3YW6nwrPZgFPhQ9"          # password for FileDaemon
  File Retention = 60 days            # 60 days
  Job Retention = 6 months            # six months
  AutoPrune = yes                     # Prune expired Jobs/Files
}

Autochanger {
  Name = File1
# Do not use "localhost" here
  Address = 127.0.0.1                # N.B. Use a fully qualified name here
  SDPort = 9103
  Password = "ubstWYlm0IRPdvVKKGbcSrUccY2B3x91l"
  Device = FileChgr1
  Media Type = File1
  Maximum Concurrent Jobs = 10        # run up to 10 jobs a the same time
  Autochanger = File1                 # point to ourself
}

Catalog {
  Name = MyCatalog
  dbname = "bacula"; DB Address = "localhost"; dbuser = "bacula"; dbpassword = "1234"
}

Messages {
  Name = Standard
  mailcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula: %t %e of %c %l\" %r"
  operatorcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula: Intervention needed for %j\" %r"
  mail = root = all, !skipped
  operator = root = mount
  console = all, !skipped, !saved
  append = "/var/log/bacula/bacula.log" = all, !skipped
  catalog = all
}

Messages {
  Name = Daemon
  mailcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula daemon message\" %r"
  mail = root = all, !skipped
  console = all, !skipped, !saved
  append = "/var/log/bacula/bacula.log" = all, !skipped
}

Pool {
  Name = Default
  Pool Type = Backup
  Recycle = yes                       # Bacula can automatically recycle Volumes
  AutoPrune = yes                     # Prune expired volumes
  Volume Retention = 365 days         # one year
  Maximum Volume Bytes = 50G          # Limit Volume size to something reasonable
  Maximum Volumes = 100               # Limit number of Volumes in Pool
}

Pool {
  Name = File
  Pool Type = Backup
  Recycle = yes                       # Bacula can automatically recycle Volumes
  AutoPrune = yes                     # Prune expired volumes
  Volume Retention = 365 days         # one year
  Maximum Volume Bytes = 50G          # Limit Volume size to something reasonable
  Maximum Volumes = 100               # Limit number of Volumes in Pool
  Label Format = "Vol-"               # Auto label
}

Pool {
  Name = Scratch
  Pool Type = Backup
}

Console {
  Name = ubuntu-master-mon
  Password = "-E9HcQtYl3j7M78iG5_c4Gf5VaUtd__nt"
  CommandACL = status, .status
}

```

#### bacula-sd.conf
```
Storage {                             # definition of myself
  Name = ubuntu-master-sd
  SDPort = 9103                  # Director's port
  WorkingDirectory = "/var/lib/bacula"
  Pid Directory = "/run/bacula"
  Plugin Directory = "/usr/lib/bacula"
  Maximum Concurrent Jobs = 20
  SDAddress = 127.0.0.1
}


Director {
  Name = ubuntu-master-dir
  Password = "ubstWYlm0IRPdvVKKGbcSrUccY2B3x91l"
}


Director {
  Name = ubuntu-master-mon
  Password = "PX8BkH2KYvhLDCZlEoy_qAV-IEaiAPvDb"
  Monitor = yes
}


Autochanger {
  Name = FileChgr1
  Device = FileChgr1-Dev1
  Changer Command = ""
  Changer Device = /dev/null
}

Device {
  Name = FileChgr1-Dev1
  Media Type = File1
  Archive Device = /mybackup/backup1
  LabelMedia = yes;                   # lets Bacula label unlabeled media
  Random Access = Yes;
  AutomaticMount = yes;               # when device opened, read it
  RemovableMedia = no;
  AlwaysOpen = no;
  Maximum Concurrent Jobs = 5
}

Messages {
  Name = Standard
  director = ubuntu-master-dir = all
}
```
#### bacula-sd.conf
```
Director {
  Name = ubuntu-master-dir
  Password = "ysAs9Npquhu1FOLtdr3YW6nwrPZgFPhQ9"
}

Director {
  Name = ubuntu-master-mon
  Password = "mMZf0OXxegPalo1i9uFMcCDnuhfv5veVz"
  Monitor = yes
}

FileDaemon {                          # this is me
  Name = ubuntu-master-fd
  FDport = 9102                  # where we listen for the director
  WorkingDirectory = /var/lib/bacula
  Pid Directory = /run/bacula
  Maximum Concurrent Jobs = 20
  Plugin Directory = /usr/lib/bacula
  FDAddress = 127.0.0.1
}

Messages {
  Name = Standard
  director = ubuntu-master-dir = all, !skipped, !restored
}
```
![Task2_1](https://raw.githubusercontent.com/Pookson/sys-pattern-homework/main/img/10.4/bacula_task2_1.png)
![Task2_2](https://raw.githubusercontent.com/Pookson/sys-pattern-homework/main/img/10.4/bacula_task2_2.png)

### Задание 3
