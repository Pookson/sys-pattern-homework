# Домашнее задание к занятию «Кеширование Redis/memcached» - `Statsenko Nikolay`

### Задание 1
Кеширование может решить ряд проблем, связанных с производительностью и эффективностью системы. Вот несколько примеров проблем, которые могут быть решены с помощью кеширования:

Проблема медленного доступа к данным: Кеширование позволяет хранить копию данных в более быстром доступном месте, например, в оперативной памяти. 
Это позволяет избежать медленного обращения к источнику данных (например, базе данных или внешнему API) и сократить время отклика системы.

Проблема повышенной нагрузки на ресурсы: Кеширование может снизить нагрузку на ресурсы, такие как базы данных или внешние сервисы, путем сохранения результатов предыдущих запросов. 
Это особенно полезно в случаях, когда одни и те же данные запрашиваются множество раз или когда данные маловероятно изменятся в течение определенного времени.

Проблема медленного выполнения вычислений: Если выполнение определенных вычислений является времязатратным, то результаты этих вычислений могут быть закешированы. 
При повторном запросе с теми же входными данными можно использовать закешированный результат вместо повторного выполнения вычислений, что значительно ускоряет процесс.

Проблема ограниченной пропускной способности сети: Кеширование может снизить нагрузку на сеть, когда данные передаются между удаленными системами. 
Закешированные данные могут быть предоставлены локально, что уменьшает количество сетевых запросов и улучшает отзывчивость системы.

Проблема обработки больших объемов данных: Кеширование может использоваться для временного хранения промежуточных результатов вычислений при обработке больших объемов данных. 
Это позволяет избежать повторного вычисления одних и тех же данных и сократить время обработки.

### Задание 2

![Task2](https://raw.githubusercontent.com/Pookson/sys-pattern-homework/main/img/11.2/memred_task2.png)

### Задание 3

#### Python script
```
import memcache
import time

# Создание соединения с memcached
client = memcache.Client(['127.0.0.1:11211'])

# Запись ключей в memcached с TTL 5, 30, 60 секунд
client.set('key0', 'value0', time=5)
client.set('key1', 'value1', time=5)
client.set('key2', 'value2', time=5)
client.set('key3', 'value3', time=30)
client.set('key4', 'value4', time=60)

# Ожидание 5 секунд
time.sleep(5)

# Проверка истечения ключей
key0_expired = client.get('key0') is None
key1_expired = client.get('key1') is None
key2_expired = client.get('key2') is None
key3_expired = client.get('key3') is None
key4_expired = client.get('key4') is None

print("Key 'key0' expired:", key0_expired)
print("Key 'key1' expired:", key1_expired)
print("Key 'key2' expired:", key2_expired)
print("Key 'key3' expired:", key3_expired)
print("Key 'key4' expired:", key4_expired)
```

![Task3](https://raw.githubusercontent.com/Pookson/sys-pattern-homework/main/img/11.2/memred_task3.png)

### Задание 4

#### Python script
```
import redis
import time

# Создание подключения к Redis
r = redis.Redis(host='localhost', port=6379)

# Запись ключей в Redis
r.setex('key0', 300, 'value0')
r.setex('key1', 300, 'value1')
r.setex('key2', 300, 'value2')
r.setex('key3', 300, 'value3')
r.setex('key4', 300, 'value4')
```

![Task4](https://raw.githubusercontent.com/Pookson/sys-pattern-homework/main/img/11.2/memred_task4.png)

### Задание 4

![Task5](https://raw.githubusercontent.com/Pookson/sys-pattern-homework/main/img/11.2/memred_task5.png)
