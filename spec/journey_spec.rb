require 'journey'

describe Journey do
  let(:entry_station) { double(:station, name: "Station 1", zone: 1)}
  let(:exit_station) { double(:station, name: "Station 2", zone: 2)}
    context 'entry station given' do
      subject { described_class.new(entry_station) }
      
      it 'sets entry_station to entry_station' do
        expect(subject.entry_station).to eq(entry_station)
      end

      it 'returns penalty fare with no exit station' do
        expect(subject.fare).to eq(Journey::PENALTY_FARE)
      end

      it 'starts a journey' do
        subject.start(entry_station)
        expect(subject.entry_station).to eq(entry_station)
      end
      context 'exit station given' do
        before do
          subject.finish(exit_station)
        end

        it 'is complete when finished with exit_station' do
          expect(subject).to be_complete
        end
      
        it 'returns 1 when given exit station' do
          expect(subject.fare).to eq(1)
        end
      end
    end
    
    it 'has an incomplete journey by default' do
      expect(subject).not_to be_complete
    end
    
    it 'sets entry station to nil' do
      expect(subject.entry_station).to be_nil
    end

    it 'finishes a journey and returns self' do
      expect(subject.finish(exit_station)).to eq(subject)
    end

    it 'saves exit station' do
      subject.finish(exit_station)
      expect(subject.exit_station).to eq(exit_station)
    end

    context 'when given an exit station' do 
      before do
        subject.finish(exit_station)
      end
      it 'is incomplete when only given an exit station' do
        expect(subject).not_to be_complete
      end

      it 'returns a penalty fare when only given 1 station' do
        expect(subject.fare).to eq(Journey::PENALTY_FARE)
      end
    end
end