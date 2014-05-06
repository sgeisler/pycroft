from flask.ext.wtf.form import Form
from web.form.fields.core import TextField, PasswordField


class LoginForm(Form):
    login = TextField()
    password = PasswordField()
