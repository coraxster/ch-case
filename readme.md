# Clickhouse bug

The case is reproduced on 19.6.2.11 version. (19.5.3.8 works fine)

## Reproducing
Clone repository
```

Run 19.6.2.11
```bash
cd ch-case
unzip case.zip
docker run -d --name some-ch-serv -v $PWD:/tmp --ulimit nofile=262144:262144 -p 9000:9000 -p 8123:8123 yandex/clickhouse-server:19.6.2.11
```

prepare parts
```bash
docker exec -it some-ch-serv bash
# Create schema
clickhouse-client --multiline --query "$(cat /tmp/schema.sql)"
cp -r /tmp/case/* /var/lib/clickhouse/data/default/case/detached
chown -R clickhouse:clickhouse /var/lib/clickhouse/data/default/case/detached
```

attach parts
```sql
ALTER TABLE default.case ATTACH PART 'aa3b78c89dbbe7528aed469902ad5701_1_1_1';
ALTER TABLE default.case ATTACH PART 'aa3b78c89dbbe7528aed469902ad5701_2_2_1';
ALTER TABLE default.case ATTACH PART 'aa3b78c89dbbe7528aed469902ad5701_3_3_1';
ALTER TABLE default.case ATTACH PART 'aa3b78c89dbbe7528aed469902ad5701_4_4_1';
ALTER TABLE default.case ATTACH PART 'aa3b78c89dbbe7528aed469902ad5701_5_5_1';
ALTER TABLE default.case ATTACH PART 'aa3b78c89dbbe7528aed469902ad5701_6_6_0';
```

try to optimize
```sql
optimize table default.case final;
>>> DB::Exception: Incorrect size of index granularity expect mark 996 totally have marks 996 (version 19.6.2.11 (official build))
```

### BONUS
drop any column and boom! Now it works.
```sql
alter table default.case drop column activation;
optimize table default.case final;
>>> completed in 9 s 784 ms
```
