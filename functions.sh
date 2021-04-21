create_readme() {
    echo "${green}>>> Creating README.md${reset}"
    cp /tmp/django-boilerplate/_README.md README.md

    sed -i "s/{PYTHON_VERSION}/$PYTHON_VERSION/g" README.md
    sed -i "s/{DJANGO_VERSION}/$DJANGO_VERSION/g" README.md
    sed -i "s/{USERNAME}/$USERNAME/g" README.md
    sed -i "s/{PROJECT}/$PROJECT/g" README.md
}

create_virtualenv() {
    echo "${green}>>> Creating virtualenv${reset}"
    python -m venv .venv
    echo "${green}>>> .venv is created${reset}"

    # active
    sleep 2
    echo "${green}>>> activate the .venv${reset}"
    source .venv/bin/activate
    PS1="(`basename \"$VIRTUAL_ENV\"`)\e[1;34m:/\W\e[00m$ "
    sleep 2
}

install_django() {
    # Install Django
    echo "${green}>>> Installing the Django${reset}"
    pip install -U pip
    pip install django==$DJANGO_VERSION dj-database-url django-extensions django-localflavor isort python-decouple ipdb
    echo Django==$DJANGO_VERSION > requirements.txt
    pip freeze | grep dj-database-url >> requirements.txt
    pip freeze | grep django-extensions >> requirements.txt
    pip freeze | grep django-localflavor >> requirements.txt
    pip freeze | grep isort >> requirements.txt
    pip freeze | grep python-decouple >> requirements.txt
}

create_env_gen() {
    echo "${green}>>> Creating contrib/env_gen.py${reset}"
    cp -r /tmp/django-boilerplate/contrib/ .

    echo "${green}>>> Running contrib/env_gen.py${reset}"
    python contrib/env_gen.py
}

create_project() {
    # Create project
    echo "${green}>>> Creating the project '$PROJECT' ...${reset}"
    django-admin.py startproject $PROJECT .
    cd $PROJECT
    echo "${green}>>> Creating the app 'core' ...${reset}"
    python ../manage.py startapp core

    echo "${green}>>> Creating the app 'accounts' ...${reset}"
    python ../manage.py startapp accounts
}

edit_settings() {
    echo "${green}>>> Editing settings.py${reset}"
    cp /tmp/django-boilerplate/settings.py $PROJECT/

    # Substitui o nome do projeto.
    sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/settings.py
    sed -i "s/{DJANGO_VERSION}/$DJANGO_VERSION/g" $PROJECT/settings.py

    # Troca import, BASE_DIR
    if [[ $response == '2' ]]; then
        sed -i "s/{LINK_VERSION}/2.2/g" $PROJECT/settings.py
        sed -i "s/# SETTINGS_IMPORT/import os/g" $PROJECT/settings.py
        sed -i "s/# SETTINGS_BASE_DIR/BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))/g" $PROJECT/settings.py
        sed -i "s/# DEFAULT_DBURL/default_dburl = 'sqlite:\/\/\/' + os.path.join(BASE_DIR, 'db.sqlite3')/g" $PROJECT/settings.py
        sed -i "s/# STATIC_ROOT/STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')/g" $PROJECT/settings.py
    else
        sed -i "s/{LINK_VERSION}/3.1/g" $PROJECT/settings.py
        sed -i "s/# SETTINGS_IMPORT/from pathlib import Path/g" $PROJECT/settings.py
        sed -i "s/# SETTINGS_BASE_DIR/BASE_DIR = Path(__file__).resolve().parent.parent/g" $PROJECT/settings.py
        sed -i "s/# DEFAULT_DBURL/default_dburl = 'sqlite:\/\/\/' + str(BASE_DIR \/ 'db.sqlite3')/g" $PROJECT/settings.py
        sed -i "s/# STATIC_ROOT/STATIC_ROOT = BASE_DIR.joinpath('staticfiles')/g" $PROJECT/settings.py
    fi
}

edit_urls() {
    echo "${green}>>> Editing urls.py${reset}"
    cp /tmp/django-boilerplate/urls.py $PROJECT/
    sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/urls.py
}

edit_accounts_urls() {
    echo "${green}>>> Editing accounts/urls.py${reset}"
    cp /tmp/django-boilerplate/accounts/urls.py $PROJECT/accounts
}

edit_core_urls() {
    echo "${green}>>> Editing core/urls.py${reset}"
    cp /tmp/django-boilerplate/core/urls.py $PROJECT/core
    sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/core/urls.py
}

edit_core_views() {
    echo "${green}>>> Editing core/views.py${reset}"
    cp /tmp/django-boilerplate/core/views.py $PROJECT/core
}

create_management_commands() {
    echo "${green}>>> Editing management/commands.${reset}"
    mkdir -p $PROJECT/core/management/commands
    cp /tmp/django-boilerplate/core/management/commands/* $PROJECT/core/management/commands
}

edit_crm_admin() {
    echo "${green}>>> Editing crm/admin.py${reset}"
    cp /tmp/django-boilerplate/crm/admin.py $PROJECT/crm
}

edit_crm_forms() {
    echo "${green}>>> Editing crm/forms.py${reset}"
    cp /tmp/django-boilerplate/crm/forms.py $PROJECT/crm
}

edit_crm_models() {
    echo "${green}>>> Editing crm/models.py${reset}"
    cp /tmp/django-boilerplate/crm/models.py $PROJECT/crm
    sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/crm/models.py
}

edit_crm_urls() {
    echo "${green}>>> Editing crm/urls.py${reset}"
    cp /tmp/django-boilerplate/crm/urls.py $PROJECT/crm
    sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/crm/urls.py
}

edit_crm_views() {
    echo "${green}>>> Editing crm/views.py${reset}"
    cp /tmp/django-boilerplate/crm/views.py $PROJECT/crm
}