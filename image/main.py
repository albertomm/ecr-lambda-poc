def handler(event, context):
    with open('build.txt', 'r', encoding='utf8') as fd:
        build = fd.read().strip()
    return f'hello lambda (build {build})'
