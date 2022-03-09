defmodule Ecommerce.Helpers.ProductUtils do
  @moduledoc """
    This is the helper module of the ecommerce project, and it is used to store useful functions.
  """
  @tax 5.15

  @doc """
    This function is used to search an product by id in a list.
    When the product is found, the name of this product will be updated in the list and
    when it is not possible to find the product by the id, the return will be the list itself.
  """
  def update_by_id([product | tail], updated_list, id, name) do
    if product.id == id do
      [Map.put(product, :name, name) | updated_list] ++ tail
    else
      update_by_id(tail, [product | updated_list], id, name)
    end
  end

  def update_by_id([], updated_list, _id, _name), do: updated_list

  @doc """
  This function is used to convert product values ​​that are priced in dollars (USD) so that the new value is the price in reais (BRL)
  """

  def convert_price([]), do: []

  def convert_price([product = %{currency: "BRL"} | next_products]) do
    [product | convert_price(next_products)]
  end

  def convert_price([product | next_products]) do
    if product.currency == "USD" do
      update_product = %{
        currency: "BRL",
        id: "#{product.id}",
        name: "#{product.name}",
        price: product.price * @tax + product.price,
        type: "#{product.type}",
        quantity: product.quantity
      }

      [update_product | convert_price(next_products)]
    end
  end

  def update_inventory(new, stock) do
    ([new] ++ [stock])
    |> List.flatten()
    |> Enum.sort_by(& &1.id)
    |> Enum.reduce(%{}, fn %{id: id, quantity: quantity}, acc ->
      Map.update(acc, id, quantity, &(&1 + quantity))
    end)
    |> Enum.map(fn {key, value} ->
      %{id: key, quantity: value}
    end)
  end

  # updated_inventory(list)

  # def updated_inventory(list) do
  #  for {value, quantity} <- Enum.group_by(list, & &1.id, & &1.quantity),
  # do: %{quantity: Enum.sum(quantity), value: value}
  # end
end
