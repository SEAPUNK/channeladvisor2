module.exports = (grunt) ->
    # Configuration
    config =
        pkg: grunt.file.readJSON 'package.json'

    config.coffee =
        compile:
            expand: true
            flatten: true
            src: ['src/*.coffee']
            dest: 'lib/'
            ext: '.js'

    config.clean =
        lib: ["lib/"]

    grunt.config.init config

    # Load plugins
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-clean'

    # Register tasks
    grunt.registerTask 'default', [
        'build'
    ]

    grunt.registerTask 'build', [
        'clean:lib'
        'coffee:compile'
    ]