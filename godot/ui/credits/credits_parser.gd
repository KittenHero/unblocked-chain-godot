extends VBoxContainer
class_name CreditsParser

@export_file("*.cfg","*.ini") var credits_file : String
@export var template_title : Label
@export var template_label : Label
@export var template_link : LinkButton
@export var template_section : Container
const LINK_SECTION := "links"
var config := ConfigFile.new()

func _ready() -> void:
	var err := config.load(credits_file)
	assert(err == OK, "Invalid credits configuration: {0}".format([credits_file]))
	assert(config.has_section(LINK_SECTION), "Credits should have [links] section")
	template_label.hide()
	template_link.hide()
	template_section.hide()
	template_title.hide()
	for section in config.get_sections():
		if section == LINK_SECTION: continue
		var title : Label = template_title.duplicate()
		title.text = section.replace("_", " ")
		add_child(title)
		title.show()
		var roles := config.get_section_keys(section)
		if roles.is_empty(): continue
		var section_block : Container = template_section.duplicate()
		add_child(section_block)
		section_block.show()
		for role in roles:
			var role_tag : Label = template_label.duplicate()
			role_tag.text = role.replace("_", " ")
			var contributor : String = config.get_value(section, role)
			var link : String = config.get_value(LINK_SECTION, contributor.replace(" ", "_"))
			var link_tag : LinkButton = template_link.duplicate()
			link_tag.text = contributor
			link_tag.uri = link
			section_block.add_child(role_tag)
			role_tag.show()
			section_block.add_child(link_tag)
			link_tag.show()
