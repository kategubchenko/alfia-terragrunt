package terraform
import input.tfplan as plan

deny[reason] {
    magical_animals := plan.variables.magic_animals_list.value
    not contains_dragon(magical_animals)
    reason := "Dog should be in the list of magical animals."
}

contains_dragon(magic_animals) {
some i
magic_animals[i] = "dog"
}
