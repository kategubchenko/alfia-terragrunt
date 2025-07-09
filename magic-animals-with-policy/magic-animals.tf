resource "null_resource" "test" {
  provisioner "local-exec" {
    command = "echo 'Hello, magic animals!'"
  }
}


resource "null_resource" "example" {
  triggers = {
    value = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "echo Resource updated at: ${self.triggers.value}"
  }
}

resource "local_file" "foo" {
  content  = "foo-2!"
  filename = "${path.module}/foo.bar"
}


#In this example, the magic_animals_list variable is defined as a list of strings representing magic animals. The resulting list will be ["unicorn", "dragon", "phoenix", "griffin"].
variable "magic_animals_list" {
  type    = list(string)
  default = ["unicorn-dry", "dragon", "phoenix", "griffin", "black cat"]
}

variable "any-bool" {
  type    = bool
  default = true
}

#In this example, the magic_animals variable is a list of objects. Each object represents a magic animal and contains attributes such as name, power, element, and description. The default value provides a list of four magic animals with their respective attributes.
variable "magic_animals" {
  type = list(object({
    name        = string
    power       = string
    element     = string
    description = string
  }))
  default = [
    {
      name        = "dry-unicorn"
      power       = "sparkle-test"
      element     = "light"
      description = "A mystical creature with a single horn on its forehead."
    },
    {
      name        = "check-second-comment-dragon-edited"
      power       = "fire"
      element     = "fire"
      description = "A powerful creature with the ability to breathe fire. Now it tests dry runs for Scalr."
    },
    {
      name        = "dry-phoenix"
      power       = "rebirth"
      element     = "fire"
      description = "A legendary bird that is reborn from its own ashes. Now it tests dry runs for Scalr. Set 2"
    },
    {
      name        = "griffin-001"
      power       = "majesty"
      element     = "air-test"
      description = "A majestic creature with the body of a lion and the head of an eagle."
    }
  ]
}


#In this example, the magic_animals_set variable is defined as a set of strings representing magic animals. The resulting set will be ["unicorn", "dragon", "phoenix", "griffin"]
variable "magic_animals_set" {
  type    = set(string)
  default = ["unicorn", "dragon", "phoenix", "griffin", "black cat", "abstract animal for testing vcs-driven run"]
}

variable "magic_animals_set2" {
  type = set(string)
  default = ["not-unicorn", "not-dragon", "not-phoenix", "not-griffin", "black cat"]
}

#In this example, the magic_animals_map variable is defined as a map of strings representing magic animals and their associated qualities. The resulting map will be { "unicorn" = "sparkle", "dragon" = "fire", "phoenix" = "rebirth", "griffin" = "majesty" }.
variable "magic_animals_map" {
  type    = map(string)
  default = {
    unicorn = "none"
    dragon  = "sleep"
    phoenix = "eat"
    griffin = "none"
  }
}

#In this example, the magic_animal_object variable is defined as an object with three attributes: name, element, and power. The resulting object will be { "name" = "Mermaid", "element" = "Water", "power" = "Enchanting Voice" }.
variable "magic_animal_object" {
  type = object({
    name    = string
    element = string
    power   = string
  })
  default = {
    name    = "Mermaid"
    element = "Water"
    power   = "Enchanting High Voice"
  }
}

#In this example, the magic_animal_tuple variable is defined as a tuple that contains three magical animal attributes: name, element, and power. The resulting tuple will be ["Centaur", "Earth", "Archery"].
variable "magic_animal_tuple" {
  type    = tuple([string, string, string])
  default = ["Centaur", "Earth", "Non-Archery-Dry-check-on-222staging"]
}

output "tuple_example" {
  value = var.magic_animal_tuple
}

output "object_example" {
  value = var.magic_animal_object
}

output "module_new_map_example" {
  value = var.magic_animals_map
}

output "set_example" {
  value = var.magic_animals_set
}

output "list_example" {
  value = var.magic_animals_list
}

output "list_example2" {
  value = var.magic_animals_list
}

output "list_example3" {
  value = var.magic_animals_list
}
