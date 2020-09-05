function vf-recreate
    set -l venv (cat .venv)
    set -l pyversion (find $HOME/.virtualenvs/$venv/bin/ -name 'python*.*' | rev | cut -d/ -f1 |rev)
    vf deactivate
    vf rm $venv
    vf new --python=(which $pyversion) $venv
    if test -f requirements.txt
        pip install -r requirements.txt
    end
end
