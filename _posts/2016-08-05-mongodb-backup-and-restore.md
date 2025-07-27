---
layout: post
title:  "몽고 DB 백업 및 복구 스크립트 작성하기"
date: 2016-08-05 14:06:22 +0900
categories: 'development'
tags: [mongodb, ruby, dump, ruby on rails]
permalink: dev/2016/08/05/mongodb-backup-and-restore.html
---

사내에서 Production 환경의 MongoDB를 백업하기 위해 스크립트를 짰는데..

mysql의 경우 pipeline 으로 바로 mysqldump \| mysql 의 방식으로 복구가 가능해서 편했는데

아무리 찾아봐도 그런 방법은 없어보여서 일단 임시 폴더에 다운받고, 복원하고, 지우는 형태로 작업을 했다.

### 기본 명령어

우선 백업 명령어는 다음과 같다

```bash
mongodump --host HOSTNAME -u USERNAME -p PASSWORD -d DATABASE_NAME BACKUP_FILE_PATH
```

복원 명령어는 아래와 같다.

```bash
mongorestore --db RESTORE_DB BACKUP_FILE_PATH/PRODUCTION_DATABASE_NAME
```

--drop 명령어를 남기면 기존의 데이터를 날리고 다시 복원한다.<br/>
기본 옵션으로 하면 아래에 추가 되는 형태라고 한다.

### sync.rake 작성

RAILS TASK 에서 Production MongoDB를 Develop에서 Sync 하기 위해 아래와 같이 스크립트를 작성하였다.

```ruby
namespace :sync do
  task :mongodb => :environment do
    backup_file_path = "#{ Rails.root }/mongo.bak"
    project_name = 'project' # 변경해야함.

    host = ENV['PRODUCTION_MONGO_SERVER']
    restore_db = "#{ project_name }_#{ Rails.env }"


    dump_statement = "mongodump --host #{ host } --db #{ project_name }_production --out #{ backup_file_path }"
    puts 'Production 환경에서 MongoDB 백업 파일을 다운 받는 중......'
    puts dump_statement
    system dump_statement

    restore_statement = "mongorestore --drop --db #{ restore_db } #{ backup_file_path }/#{project_name}_production"
    puts '백업 파일로 development 환경의 DB를 갱신합니다.'
    puts restore_statement
    system resotre_statement

    remove_tmp_backup_statement = "rm -r #{ backup_file_path }"
    puts '임시파일을 삭제합니다'
    puts remove_tmp_backup_statement
    system remove_tmp_backup_statement

    puts '----- 완료 -----'
  end
end
```

lib/task/sync.rake에 저장한다.

### 실행방법

```bash
bundle exec rake sync:mongodb
```
