require 'oystercard'

describe Oystercard do
  let(:entry_station) { double("Station", :name => "Finsbury Park") }
  let(:exit_station) { double("Station", :name => "Bethnal Green") }
  let(:journey) { {entry_station: entry_station, exit_station: exit_station} }

  describe '.new' do
    it 'checks that default balance is zero' do
      expect(subject.balance).to eq (0)
    end
    it 'checks journey log is empty by default' do
      expect(subject.journeys).to be_empty
    end
  end

  describe '#top_up' do
    it 'can add to the balance' do
      expect{ subject.top_up(5) }.to change{ subject.balance }.by 5
    end
    it 'raises error when balance is over 90' do
      expect{ subject.top_up(91) }.to raise_error "Maximum balance of #{Oystercard::MAXIMUM_BALANCE} exceeded"
    end
  end

  describe '#touch_in' do
    context 'with sufficient funds' do
      before(:each) do
        subject.top_up(Oystercard::MAXIMUM_BALANCE)
        subject.touch_in(entry_station)
      end
      it 'saves entry_station' do
        expect(subject.entry_station).to eq(entry_station)
      end
    
      it 'sets in_journey to true' do
        expect(subject.in_journey?).to eq (true)
      end
    end
    context 'without sufficient funds' do
      it 'raises an error' do
        expect{ subject.touch_in(entry_station) }.to raise_error "Insufficent balance"
      end
    end
  end

  describe '#touch_out' do
    context 'after touching in' do
      before(:each) do
        subject.top_up(Oystercard::MAXIMUM_BALANCE)
        subject.touch_in(entry_station)
        subject.touch_out(exit_station)
      end
      it 'changes in_journey to false' do
        expect(subject.in_journey?).to eq (false)
      end
      it 'deducts from the balance on touch out' do
        expect(subject.balance).to eq(89)
      end
      it 'sets entry_station to nil' do
        expect(subject.entry_station).to eq(nil)
      end
      it 'saves exit_station' do
        expect(subject.exit_station).to eq(exit_station)
      end
    end
  end
  describe '#journeys' do
    it 'stores journey' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journeys.include?(journey)).to eq(true)
    end
  end
end
