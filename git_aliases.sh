# Git Aliases
# Основные команды
function git_info() {
    echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
    echo "Статус:"
    git status
    echo "Удаленные репозитории:"
    git remote -v
}

function git_log_find() {
  echo "Поиск: $1"
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Удаленные репозитории:"
  git remote -v
  echo "Результаты поиска:"
  git log --grep="$1"
}

function gln() {
  echo "Поиск: $1"
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Удаленные репозитории:"
  git remote -v
  echo "Результаты п��иска:"
  git log --pretty=oneline --abbrev-commit -"$1"
}

function stash() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Stash list:"
  git stash list
  echo "Stash add:"
  echo "Введите название stash:"
  read stash_name
  git stash save "$stash_name"
}

function stash_pop() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Stash list:"
  git stash list
  echo "Stash pop:"
  echo "Введите название stash:"
  read stash_name
  git stash pop "$stash_name"
}

function stash_drop() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Stash list:"
  git stash list
  echo "Stash drop:"
  echo "Введите название stash:"
  read stash_name
  git stash drop "$stash_name"
}

function stash_push() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Stash list:"
  git stash list
  echo "Stash push:"
  echo "Введите название stash:"
  read stash_name
  git stash push "$stash_name"
}

function stash_apply() {
  echo "Текущая ��етка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Stash list:"
  git stash list
  echo "Stash apply:"
  echo "Введите название stash:"
  read stash_name
  git stash apply "$stash_name"
}

function git_branch() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Branch list:"
  git branch
}

function new_branch() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "New branch:"
  echo "Введите название ветки:"
  read branch_name
  git checkout -b "$branch_name"
}

function git_checkout() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Branch list:"
  git branch
  echo "Checkout:"
  echo "Введите название ветки:"
  read branch_name
  git checkout "$branch_name"
}

function branch_delete() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Введите название ветки:"
  read branch_name
  git branch -d "$branch_name"
  git push origin --delete "$branch_name"
}

function branch_rename() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Rename branch:"
  echo "Введите название ветки:"
  read branch_name
  git branch -m "$branch_name"
  git push origin -u "$branch_name"
}

function git_diff() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Branch list:"
  git branch
  echo "Diff:"
  echo "Введите название ветки:"
  read branch_name
  git diff "$branch_name"
}

function git_diff_cached() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Branch list:"
  git branch
  echo "Diff cached:"
  echo "Введите название ветки:"
  read branch_name
  git diff --cached "$branch_name"
}

function git_show_branch() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Branch list:"
  git branch
  echo "Show branch:"
  echo "Введите название ветки:"
  read branch_name
  git show-branch "$branch_name"
}

function git_reset() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Ст��тус:"
  git status
  echo "Branch list:"
  git branch
  echo "Reset:"
  echo "Введите название ветки:"
  read branch_name
  git reset "$branch_name"
}

function git_merge() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Branch list:"
  git branch
  echo "Merge:"
  echo "Введите название ветки:"
  read branch_name
  git merge "$branch_name"
}

function git_rebase() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Branch list:"
  git branch
  echo "Rebase:"
  echo "Введите название ветки:"
  read branch_name
  git rebase "$branch_name"
}

function git_reset_hard() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Branch list:"
  git branch
  echo "Reset hard:"
  echo "Введите название ветки:"
  read branch_name
  git reset --hard "$branch_name"
}

function git_reset_soft() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Branch list:"
  git branch
  echo "Reset soft:"
  echo "Введите н��звание ветки:"
  read branch_name
  git reset --soft "$branch_name"
}

function git_reset_mixed() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Branch list:"
  git branch
  echo "Reset mixed:"
  echo "Введите название ветки:"
  read branch_name
  git reset --mixed "$branch_name"
}

function git_merge_base() {
  echo "Текущая ветка: $(git rev-parse --abbrev-ref HEAD)"
  echo "Статус:"
  git status
  echo "Branch list:"
  git branch
  echo "Merge base:"
  echo "Введите название ветки:"
  read branch_name
  git merge-base "$branch_name"
}


# Алиасы
alias g='git'
alias ga='git add --all'
alias gc='git commit -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gch='git checkout'
alias gchb='git checkout -b'
alias glo='git log --graph --pretty=oneline --abbrev-commit'
alias glg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gco='git checkout'
alias gs='git status'
alias gst='git stash'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gstd='git stash drop'
alias gsp='git stash push'
alias gsa='git stash apply'
alias gsb='git show-branch'
alias gsh='git show'
alias gshc='git show --pretty=fuller --name-status'
alias gshw='git show --patch'


