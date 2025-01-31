notebook() {
    today=$(date +%Y-%m-%d)
    year_dir="${today:0:4}"
    month_dir="${today:5:2}"
    filename="${today}.md"
    
    # Создаем директорию для заметок
    notes_dir="/home/user/Nextcloud/Notes/$year_dir/$month_dir"
    mkdir -p "$notes_dir" || echo "Директория $notes_dir уже существует."
    
    # Переходим в директорию и открываем файл в lvim
    cd "$notes_dir" && lvim "$filename"
}

tasks() {
    today=$(date +%Y-%m-%d)
    year_dir="${today:0:4}"
    month_dir="${today:5:2}"
    filename="${today}.md"
    
    # Создаем директорию для задач
    tasks_dir="/home/user/Nextcloud/Tasks/$year_dir/$month_dir"
    mkdir -p "$tasks_dir" || echo "Директория $tasks_dir уже существует."
    
    # Переходим в директорию и открываем файл в lvim
    cd "$tasks_dir" && lvim "$filename"
}
