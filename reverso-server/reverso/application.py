from flask import Flask
from flask import request
from reverso_context_api import Client
import itertools
import pyconvert.pyconv
from werkzeug.exceptions import HTTPException

# history objects

class History(object):
	translations = []
	source_lang = ""
	source_text = ""
	target_lang = ""
	
	def __init__(self, translations, source_lang, source_text, target_lang):
		self.translations = translations
		self.source_lang = source_lang
		self.source_text = source_text
		self.target_lang = target_lang

class HistoryResponse(object):
	histories = [History]
	
	def __init__(self, histories):
		self.histories = histories

# favorites object

class Favorite(object):
	source_lang = ""
	source_text = ""
	source_context = ""
	
	target_lang = ""
	target_text = ""
	target_context = ""
	
	def __init__(self, source_lang, source_text, source_context, target_lang, target_text, target_context):
		self.source_lang = source_lang
		self.source_text = source_text
		self.source_context = source_context
	
		self.target_lang = target_lang
		self.target_text = target_text
		self.target_context = target_context

class FavoritesResponse(object):
	favorites = [Favorite]
	
	def __init__(self, favorites):
		self.favorites = favorites

class Credentials(object):
	email = ""
	password = ""
	
	def __init__(self, email, password):
		self.email = email
		self.password = password

# error object

class EHTTPError(object):
	code = ""
	name = ""
	description = ""
	
	def __init__(self, code, name, description):
		self.code = code
		self.name = name
		self.description = description

# context objects

class Sample(object):
    source_example = ""
    target_example = ""

    def __init__(self, source_example, target_example):
        self.source_example = source_example
        self.target_example = target_example

class SamplesResponse(object):
    samples = [Sample]

    def __init__(self, samples):
        self.samples = samples

# translation objects

class Translation(object):
    translation = ""
    original = ""

    def __init__(self, translation, original):
        self.translation = translation
        self.original = original

class TranslationsResponse(object):
    translations = [Translation]

    def __init__(self, translations):
        self.translations = translations

# serach suggestions objects

class Suggestion(object):
    suggestion = ""

    def __init__(self, suggestion):
        self.suggestion = suggestion

class SuggestionsResponse(object):
    suggestions = [Suggestion]

    def __init__(self, suggestions):
        self.suggestions = suggestions

app = Flask(__name__)

def getContext(text, inputlang, outputlang, number):
    client = Client(inputlang, outputlang)

    phrases = []
    for context in itertools.islice(client.get_translation_samples(text, cleanup=True), number):
        phrases.append(Sample(context[0], context[1]))

    response = SamplesResponse(phrases)

    json_translations = pyconvert.pyconv.convert2XML(response)
    print(json_translations.toprettyxml())
    return json_translations.toprettyxml()

def getTranslation(text, inputlang, outputlang, number):
    client = Client(inputlang, outputlang)

    words = []
    for translation in itertools.islice(client.get_translations(text), number):
        words.append(Translation(translation, text))

    response = TranslationsResponse(words)

    json_translations = pyconvert.pyconv.convert2XML(response)
    print(json_translations.toprettyxml())
    return json_translations.toprettyxml()

def getSearchSuggestions(text, inputlang, outputlang, number):
    client = Client(inputlang, outputlang)

    suggestions = []
    for suggestion in itertools.islice(client.get_search_suggestions(text), number):
        suggestions.append(Suggestion(suggestion))

    response = SuggestionsResponse(suggestions)

    json_translations = pyconvert.pyconv.convert2XML(response)
    print(json_translations.toprettyxml())
    return json_translations.toprettyxml()
	
def getFavorites(inputlang, outputlang, credentials, number):
	client = Client(inputlang, outputlang, credentials=(credentials.email, credentials.password))
	
	favorites = []
	for favorite in itertools.islice(client.get_favorites(), number):
		favorites.append(Favorite(favorite["source_lang"], favorite["source_text"], favorite["source_context"], favorite["target_lang"], favorite["target_text"], favorite["target_context"]))

	response = FavoritesResponse(favorites)
	json_favorites = pyconvert.pyconv.convert2XML(response)
	print(json_favorites.toprettyxml())
	return json_favorites.toprettyxml()

def getHistory(inputlang, outputlang, credentials, number):
	client = Client(inputlang, outputlang, credentials=(credentials.email, credentials.password))
	
	histories = []
	for history in itertools.islice(client.get_history(), number):
		histories.append(History(history["translations"], history["source_lang"], history["source_text"], history["target_lang"]))
		
	response = HistoryResponse(histories)
	xml_history = pyconvert.pyconv.convert2XML(response)
	print(xml_history.toprettyxml())
	return xml_history.toprettyxml()

@app.route("/")
def homepage():

    # collecting parameters

	service = request.args.get('service')
	text = request.args.get('text')
	inputlang = request.args.get('inputlang')
	outputlang = request.args.get('outputlang')
	number = request.args.get('number', default = 10, type=int)
	email = request.args.get('email')
	password = request.args.get('password')
	
	credentials = Credentials(email, password)
	
	if service == "context":
		return getContext(text, inputlang, outputlang, number)
	elif service  == "translation":
		return getTranslation(text, inputlang, outputlang, number)
	elif service == "suggestions":
		return getSearchSuggestions(text, inputlang, outputlang, number)
	elif service == "favorites":
		return getFavorites(inputlang, outputlang, credentials, number)
	elif service == "history":
		return getHistory(inputlang, outputlang, credentials, number)
	else:
		return "wrong or unspecified service"

@app.errorhandler(HTTPException)
def handle_exception(e):
    response = e.get_response()
    http_error = HTTPError(e.code, e.name, e.description)
    error_xml = pyconvert.pyconv.convert2XML(http_error)
    return error_xml.tooprettyxml()
