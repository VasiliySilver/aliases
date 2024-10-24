function note() {
    local current_dir="$HOME/Nextcloud/Notes"
    local today=$(date +%Y-%m-%d)
    local year_dir="$current_dir/${today:0:4}"
    local month_dir="$year_dir/${today:5:2}"

    mkdir -p "$year_dir/$month_dir" || echo "Директория $year_dir/$month_dir уже существует."

    local filename="${today}.md"
    local full_path="$year_dir/$month_dir/$filename"

    if [ ! -f "$full_path" ]; then
        touch "$full_path"
        echo "Файл $full_path создан."
    else
        echo "Файл $full_path уже существует."
    fi

    lvim "$full_path"
}

