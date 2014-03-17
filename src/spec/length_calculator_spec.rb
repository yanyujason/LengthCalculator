require 'length_calculator'

describe 'length calculate' do

  subject {LengthCalculator.new}

  describe 'calculate' do
    it 'should be 3m when only having meters 1m+2m' do
      expect(subject.unit_translator('1m+2m')).to eq 3
    end

    it 'should be 7m when having multiple calculating types: 2m*3+1m' do
      expect(subject.unit_translator('2m*3+1m')).to eq 7
    end

    it 'should be 2.1m when having multiple units: 1dm+2m' do
      expect(subject.unit_translator('1dm+2m')).to eq 2.1
    end

    it 'should be 6.1m when having multiple units and calculating types: 2m*3+1dm' do
      expect(subject.unit_translator('2m*3+1dm')).to eq 6.1

    end

    it 'should be 6.099m when having all units and types: 2m*3+1dm+5cm/5-1mm' do
      expect(subject.unit_translator('2m*3+1dm+5cm/5-1mm')).to eq 6.109
    end

    it 'should be 3.0when calculating: 3m+4dm*10-4m' do
      expect(subject.unit_translator('3m+4dm*10-4m')).to eq 3.0
    end
  end

end