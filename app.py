from flask import Flask, jsonify, request, render_template
from flask_sqlalchemy import SQLAlchemy
from config import Config

app = Flask(__name__)
app.config.from_object(Config)

db = SQLAlchemy(app)


@app.route('/', methods=['GET', 'POST'])
def consulta():
    if request.method == 'GET':
        return render_template('index.html')
    elif request.method == 'POST':
        # Obtén la consulta SQL desde la solicitud POST
        consulta_sql = request.json['consulta']
        # Ejecuta la consulta en la base de datos
        resultado = db.engine.execute(consulta_sql)
        # Convierte el resultado en una lista de diccionarios
        resultados_dict = [dict(row) for row in resultado]
        print(resultados_dict)
        return jsonify(resultados_dict)
    else:
        pass


if __name__ == '__main__':
    app.run(debug=True)
