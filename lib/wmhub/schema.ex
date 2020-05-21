defmodule Wmhub.Schema do
    @moduledoc """
    The Wmhub.Schema module is a facade module to Ecto.Schema.
    This schema defines primary and foreign keys as UUIDs. Otherwise, it is equivalent
    to Ecto.Schema.

    Should be used in favor of Ecto.Schema in schema modules that deal with persistence.
    """
    defmacro __using__(_) do
        quote do
            use Ecto.Schema
            import Ecto.Changeset
            @primary_key {:id, :binary_id, autogenerate: true}
            @foreign_key_type :binary_id
        end
    end
end