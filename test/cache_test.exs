defmodule CacheTest do
  use ExUnit.Case
  doctest Cache

  setup do
    assert {:ok, pid} = Cache.start_link
    %{pid: pid}
  end

  test "init a new cache returns it results on a :ok tuple" do
    assert :ok = Cache.write(:stooges, ["Larry", "Curly", "Moe"])
  end

  test "read a cache return it's elements" do
    values = ["banana", "apple", "avocato"]
    assert :ok = Cache.write(:fruits, values)
    assert Cache.read(:fruits) == values
  end

  test "deletes an entry from cache" do
    assert :ok = Cache.write(:color, "black")
    assert Cache.read(:color) == "black"
    assert :ok = Cache.delete(:color)
    assert Cache.read(:color) == nil
  end

  test "gets all entries" do
    assert :ok = Cache.write(:color, "black")
    assert :ok = Cache.write(:food, "hamburger")
    assert %{color: "black", food: "hamburger"} == Cache.get_all
  end

  test "clear cache" do
    assert :ok = Cache.write(:color, "black")
    assert :ok = Cache.write(:food, "hamburger")
    assert %{color: "black", food: "hamburger"} == Cache.get_all
    assert :ok = Cache.clear()
    assert %{} = Cache.get_all
  end

  test "check if entry exists in cache" do
    assert :ok = Cache.write(:color, "black")
    assert Cache.exists?(:color)
    refute Cache.exists?(:inexistent)
  end


end
