BUILD_FOLDER = build
SOURCE_FOLDER = src
# Folders under 'SOURCE_FOLDER' to be copied directly
# ! It doesn't support nested folders
COPY_FOLDERS = deps img
# Sass compiler
# ! Beware that changing the compiler might break this script
# ! Modify the 'sass' task accordingly to your compiler usage
SASS_COMP = sassc
SASS_FLAGS =
SASS_FOLDER = $(SOURCE_FOLDER)/css
SASS_FILES := $(shell find $(SASS_FOLDER) -name '*.scss')

#---------------#
#  _T_A_S_K_S_  #
#               #
# · all         #
# · init        #
# · clean       #
# · rebuild     #
# · copy        #
# · sass        #
# · handlebars  #
#---------------#

### ALL
all: copy sass

### INIT
init:
	##### Creating source folders...
	mkdir -p $(SASS_FOLDER) $(SOURCE_FOLDER)/deps $(SOURCE_FOLDER)/img $(SOURCE_FOLDER)/js/templates

### CLEAN
clean:
	##### Deleting the build...
	rm -rf $(BUILD_FOLDER)

### REBUILD
rebuild: clean all

### COPY
copy: $(COPY_FOLDERS)
$(COPY_FOLDERS):
	##### Copying assets...
	mkdir -p $(addprefix $(BUILD_FOLDER)/, $(COPY_FOLDERS))
	rsync -rupE $(SOURCE_FOLDER)/$@ $(BUILD_FOLDER)

### SASS
sass: $(SASS_FILES)
	##### Compiling Sass files...
	mkdir -p $(BUILD_FOLDER)/css
	@# Current call structure: command [flags] [INPUT] [OUTPUT]
	@# ! Depends on the compiler
	$(foreach file, $(SASS_FILES), \
	  $(SASS_COMP) $(SASS_FLAGS) $(file) \
		  $(addprefix $(BUILD_FOLDER)/css/, $(notdir $(basename $(file))).css);)
			@# Transforms 'origin/css/example.scss' into 'destination/css/example.css'

.PHONY: clean rebuild all sass copy $(COPY_FOLDERS) init
