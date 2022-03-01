defmodule Product do
  defstruct name: nil, type: nil, value: 500
  @discount 15

  def create(params) do
    name = Keyword.get(params, :name)
    value = Keyword.get(params, :value)
    type = Keyword.get(params, :type)

    %Product{name: name, value: value, type: type}
  end

  def add_product_to_list(product, list \\ []) do
    [product | list]
  end

  def product_exist_list(list, product) do
    Enum.find(list, fn x -> x.name == product end)
  end

  def add_product_to_cart(cart, product = %Product{type: "Periphericals"}) do
    discount = product.value * @discount / 100
    new_value = product.value - discount
    product = Map.put(product, :value, new_value)
    # Map.put params: map ou struct, field, new value
    [product | cart]
    # [Map.put(new_product_cart, :value, discount)| product_in_cart]
  end

  # underline = não me importo com o conteúdo carregado
  def add_product_to_cart(cart, product = %Product{}) do
    [product | cart]
  end
end
