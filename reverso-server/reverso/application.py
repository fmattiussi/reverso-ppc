from flask import Flask
from flask import request
from reverso_context_api import Client
import itertools
import pyconvert.pyconv

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

@app.route("/")
def homepage():

    # collecting parameters

    service = request.args.get('service')
    text = request.args.get('text')
    inputlang = request.args.get('inputlang')
    outputlang = request.args.get('outputlang')
    number = request.args.get('number', default = 10, type=int)

    if text == "":
        return "the text to translate hasn't been specified"
    elif inputlang == "":
        return "the source language hasn't been specified"
    elif outputlang == "":
        return "the target language hasn't been specified"

    if service == "context":
        return getContext(text, inputlang, outputlang, number)
    elif service  == "translation":
        return getTranslation(text, inputlang, outputlang, number)
    elif service == "suggestions":
        return getSearchSuggestions(text, inputlang, outputlang, number)
    else:
        return "wrong or unspecified service"
