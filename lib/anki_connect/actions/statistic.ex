defmodule AnkiConnect.Actions.Statistic do
  @moduledoc """
  Statistic actions.

  All functions are delegated inside `AnkiConnect` module, so you should import them from there.
  """

  import AnkiConnect.Client

  @doc """
  Gets the count of cards that have been reviewed in the current day (with day start time as configured by user in anki)

  ### Sample result:
  ```
  {:ok, 0}
  ```
  """
  @spec get_num_cards_reviewed_today() :: {:ok, integer()} | {:error, any()}
  def get_num_cards_reviewed_today do
    api("getNumCardsReviewedToday")
  end

  @doc """
  Gets the number of cards reviewed as a list of pairs of (dateString, number)

  ### Sample result:
  ```
  [
    ["2021-02-28", 124],
    ["2021-02-27", 261]
  ]
  ```
  """
  @spec get_num_cards_reviewed_by_day() :: {:ok, [[any()]]} | {:error, any()}
  def get_num_cards_reviewed_by_day do
    api("getNumCardsReviewedByDay")
  end

  @doc """
  Gets the collection statistics report

  ### Sample param:
  ```
  %{
    whole_collection: true
  }
  ```

  ### Sample result:
  ```
  {:ok, "<html>...</html>"}
  ```
  """
  @spec get_collection_stats_html(%{whole_collection: boolean() | nil}) ::
          {:ok, String.t()} | {:error, any()}
  def get_collection_stats_html(
        %{whole_collection: whole_collection} \\ %{whole_collection: true}
      ) do
    api("getCollectionStats", %{whole_collection: whole_collection})
  end

  @doc """
  Requests all card reviews for a specified deck after a certain time.

  `start_id` is the latest unix time not included in the result.

  Returns a list of 9-tuples (`reviewTime`, `cardID`, `usn`, `buttonPressed`, `newInterval`, `previousInterval`, `newFactor`, `reviewDuration`, `reviewType`)

  ### Sample param:
  ```
  %{
    deck: "default",
    start_id: 1594194095740
  }
  ```

  ### Sample result:
  ```
  [
    [1594194095746, 1485369733217, -1, 3,   4, -60, 2500, 6157, 0],
    [1594201393292, 1485369902086, -1, 1, -60, -60,    0, 4846, 0]
  ]
  ```
  """
  @spec card_reviews(%{deck: String.t(), start_id: integer()}) ::
          {:ok, [[any()]]} | {:error, any()}
  def card_reviews(%{deck: deck, start_id: start_id}) do
    api("cardReviews", %{deck: deck, start_id: start_id})
  end

  @doc """
  Requests all card reviews for each card ID.

  Returns a dictionary mapping each card ID to a list of dictionaries of the format:
  ```
  {
    "id": reviewTime,
    "usn": usn,
    "ease": buttonPressed,
    "ivl": newInterval,
    "lastIvl": previousInterval,
    "factor": newFactor,
    "time": reviewDuration,
    "type": reviewType,
  }
  ```

  The reason why these key values are used instead of the more descriptive counterparts is because these are the exact key values used in Anki’s database.

  ### Sample param:
  ```
  %{
    cards: [
      "1653613948202"
    ]
  }
  ```

  ### Sample result:
  ```
  {
    "1653613948202": [
      {
        "id": 1653772912146,
        "usn": 1750,
        "ease": 1,
        "ivl": -20,
        "lastIvl": -20,
        "factor": 0,
        "time": 38192,
        "type": 0
      },
      {
        "id": 1653772965429,
        "usn": 1750,
        "ease": 3,
        "ivl": -45,
        "lastIvl": -20,
        "factor": 0,
        "time": 15337,
        "type": 0
      }
    ]
  }
  ```
  """
  @spec get_reviews_of_cards(%{cards: [String.t()]}) ::
          {:ok, map()} | {:error, any()}
  def get_reviews_of_cards(%{cards: cards}) do
    api("getReviewsOfCards", %{cards: cards})
  end

  @doc """
  Returns the unix time of the latest review for the given deck.

  0 if no review has ever been made for the deck.

  ### Sample param:
  ```
  %{
    deck: "default"
  }
  ```

  ### Sample result:
  ```
  {:ok, 1594194095746}
  ```
  """
  @spec get_latest_review_id(%{deck: String.t()}) :: {:ok, integer()} | {:error, any()}
  def get_latest_review_id(%{deck: deck}) do
    api("getLatestReviewID", %{deck: deck})
  end

  @doc """
  Inserts the given reviews into the database.

  Required format: list of 9-tuples (reviewTime, cardID, usn, buttonPressed, newInterval, previousInterval, newFactor, reviewDuration, reviewType)

  ### Sample param:
  ```
  %{
    reviews: [
      [1594194095746, 1485369733217, -1, 3,   4, -60, 2500, 6157, 0],
      [1594201393292, 1485369902086, -1, 1, -60, -60,    0, 4846, 0]
    ]
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec insert_reviews(%{reviews: [[any()]]}) :: {:ok, nil} | {:error, any()}
  def insert_reviews(%{reviews: reviews}) do
    api("insertReviews", %{reviews: reviews})
  end
end
