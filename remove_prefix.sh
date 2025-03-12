#!/bin/bash

# Функция для получения используемой памяти в МБ
get_current_memory() {
    ps -o rss= -p $$ | awk '{printf "%.2f", $1/1024}'
}

# Запрашиваем префиксы для удаления
read -p "Введите префиксы, которые нужно удалить (через запятую): " prefixes_input
IFS=',' read -ra temp_prefixes <<< "$prefixes_input"

# Очищаем и проверяем префиксы
prefixes=()
for p in "${temp_prefixes[@]}"; do
    trimmed_p=$(echo "$p" | xargs)
    [ -n "$trimmed_p" ] && prefixes+=("$trimmed_p")
done

if [ ${#prefixes[@]} -eq 0 ]; then
    echo "Ошибка: Не указаны префиксы!" >&2
    exit 1
fi

# Запрашиваем путь к папке
read -p "Введите путь к папке: " folder_path
if [ ! -d "$folder_path" ]; then
    echo "Ошибка: Папка не существует!" >&2
    exit 1
fi

# Старт скрипта
echo -e "\nЗапуск процесса переименования..."
start_time=$(date +%s.%N)
start_memory=$(get_current_memory)
processed_files=0
processed_folders=0

# Обрабатываем элементы с глубины
while IFS= read -r -d '' path; do
    name=$(basename "$path")
    dir=$(dirname "$path")
    new_name="$name"

    # Удаляем все префиксы
    for prefix in "${prefixes[@]}"; do
        while : ; do
            prefix_len=${#prefix}
            [ ${#new_name} -lt $prefix_len ] && break
            [ "${new_name:0:$prefix_len}" != "$prefix" ] && break
            new_name="${new_name:$prefix_len}"
        done
    done

    # Проверяем изменения
    [ -z "$new_name" ] && echo "Ошибка: Пустое имя для '$path'" >&2 && continue
    [ "$new_name" = "$name" ] && continue

    new_path="$dir/$new_name"
    
    # Переименовываем если возможно
    if [ -e "$path" ]; then
        if [ ! -e "$new_path" ]; then
            if mv -- "$path" "$new_path" 2>/dev/null; then
                if [ -d "$new_path" ]; then
                    ((processed_folders++))
                    echo -e "[Папка] $path -> $new_path"
                else
                    ((processed_files++))
                    echo -e "[Файл]  $path -> $new_path"
                fi
            else
                echo "Ошибка переименования: $path" >&2
            fi
        else
            echo "Конфликт: '$new_path' существует!" >&2
        fi
    else
        echo "Не найден: $path" >&2
    fi
done < <(find "$folder_path" -mindepth 1 -depth -print0)

# Вывод статистики
end_time=$(date +%s.%N)
end_memory=$(get_current_memory)

time_diff=$(echo "$end_time - $start_time" | bc -l | awk '{printf "%.3f", $1}')
memory_diff=$(echo "$end_memory - $start_memory" | bc -l | awk '{printf "%.2f", $1}')

echo -e "\nОтчёт:"
echo "-----------------"
echo "Время выполнения: ${time_diff} сек."
echo "Использовано памяти: ${memory_diff} МБ"
echo "Обработано папок: $processed_folders"
echo "Обработано файлов: $processed_files"
echo -e "\nГотово! Префиксы удалены.\n"