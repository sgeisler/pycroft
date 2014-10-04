# -*- coding: utf-8 -*-

from pycroft.lib.user import has_positive_balance, has_exceeded_traffic

_check_registry = {}


def template_check(name):
    def decorator(fn):
        _check_registry[name] = fn
        return fn
    return decorator


@template_check("user_with_positive_balance")
def positive_balance_check(user):
    """Tests if user has a positive balance
    """
    return has_positive_balance(user)


@template_check("user_with_no_internet")
def no_internet_check(user):
    """Tests if user has no internet
    """
    return not user.has_property("internet")


@template_check("user_with_traffic_exceeded")
def exceeded_traffic_check(user):
    """Tests if user has exceeded his traffic
    """
    return has_exceeded_traffic(user)

@template_check("privileged_for")
def privilege_check(user, *required_privileges):
    """Tests if the user has one of the required_privileges to view the
    requested component.
    """
    for perm in required_privileges:
        if user.has_property(perm):
            return True
    return False


@template_check("greater")
def greater(value, other):
    """Tests if another value is greater than a given value."""
    return value < other


@template_check("less")
def less(value, other):
    """Tests if another value is less than a given value."""
    return value > other


@template_check("greater_equal")
def greater_equal(value, other):
    """Tests if another value is greater than or equal a given value."""
    return value <= other


@template_check("less_equal")
def less_equal(value, other):
    """Tests if another value is less than or equal a given value."""
    return value >= other


@template_check("is_dict")
def is_dict(value):
    return isinstance(value, dict)


def register_checks(app):
    for name in _check_registry:
        app.jinja_env.tests[name] = _check_registry[name]