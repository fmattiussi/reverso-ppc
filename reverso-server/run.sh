app=application.py

source venv/bin/activate
echo "venv activated"

export FLASK_APP=$app
echo "path exported"

cd ./reverso

echo "launching flask at $1"

flask run --host $1
