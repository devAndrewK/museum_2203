require './lib/museum'
require './lib/patron'
require './lib/exhibit'
RSpec.describe Museum do

  it 'exists' do
    dmns = Museum.new("Denver Museum of Nature and Science")
    expect(dmns).to be_a(Museum)
  end

  it 'has attributes' do
    dmns = Museum.new("Denver Museum of Nature and Science")
    expect(dmns.name).to eq("Denver Museum of Nature and Science")
    expect(dmns.exhibits).to eq([])
    expect(dmns.patrons).to eq([])
  end

  it 'can add exhibits' do
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    expect(dmns.exhibits).to eq([gems_and_minerals, dead_sea_scrolls, imax])
  end

  it 'can recommend exhibits' do
    dmns = Museum.new("Denver Museum of Nature and Science")
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    patron_1 = Patron.new("Bob", 20)
    patron_1.add_interest("Dead Sea Scrolls")
    patron_1.add_interest("Gems and Minerals")
    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")
    expect(dmns.recommend_exhibits(patron_1)).to eq([dead_sea_scrolls, gems_and_minerals])
    expect(dmns.recommend_exhibits(patron_2)).to eq([imax])
  end

  it 'can have patrons' do
    dmns = Museum.new("Denver Museum of Nature and Science")
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1 = Patron.new("Bob", 20)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")
    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("Dead Sea Scrolls")
    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)
    expect(dmns.patrons).to eq([patron_1, patron_2, patron_3])
  end

  it 'can return patrons by exhibit interest' do
    dmns = Museum.new("Denver Museum of Nature and Science")
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1 = Patron.new("Bob", 20)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")
    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("Dead Sea Scrolls")
    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)
    expected = {
      gems_and_minerals => [patron_1],
      dead_sea_scrolls => [patron_1, patron_3],
      imax => [patron_2]
    }
    expect(dmns.patrons_by_exhibit_interest).to eq(expected)
  end

  it 'can return array of lottery contestants' do
    dmns = Museum.new("Denver Museum of Nature and Science")
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")
    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("Dead Sea Scrolls")
    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)
    expect(dmns.ticket_lottery_contestants(dead_sea_scrolls)).to eq([patron_1, patron_3])
  end

  it 'can return lottery winner' do
    dmns = Museum.new("Denver Museum of Nature and Science")
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")
    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("Dead Sea Scrolls")
    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)
    expected = [patron_1, patron_3]
    expect(dmns.draw_lottery_winner(dead_sea_scrolls)).to be_a(Patron)
    expect(dmns.draw_lottery_winner(gems_and_minerals)).to eq(nil)
  end
end
