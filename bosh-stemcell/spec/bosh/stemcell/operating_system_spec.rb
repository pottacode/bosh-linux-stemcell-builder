require 'spec_helper'
require 'bosh/stemcell/operating_system'

module Bosh::Stemcell
  describe OperatingSystem do
    describe '.for' do
      it 'returns the correct infrastrcture' do
        expect(OperatingSystem.for('ubuntu', 'penguin')).to be_a(OperatingSystem::Ubuntu)
      end

      it 'raises for unknown operating system' do
        expect {
          OperatingSystem.for('BAD_OPERATING_SYSTEM', 'BAD_OS_VERSION')
        }.to raise_error(ArgumentError, /invalid operating system: BAD_OPERATING_SYSTEM/)
      end
    end
  end

  describe OperatingSystem::Base do
    describe '#initialize' do
      it 'requires :name to be specified' do
        expect {
          OperatingSystem::Base.new
        }.to raise_error /key not found: :name/
      end

      it 'requires :version to be specified' do
        expect {
          OperatingSystem::Base.new(name: 'CLOUDY_PONY_OS')
        }.to raise_error /key not found: :version/
      end
    end

    describe '#name' do
      subject { OperatingSystem::Base.new(name: 'CLOUDY_PONY_OS', version: 'HORSESHOE') }

      its(:name) { should eq('CLOUDY_PONY_OS') }
    end

    describe '#version' do
      subject { OperatingSystem::Base.new(name: 'CLOUDY_PONY_OS', version: 'HORSESHOE') }

      its(:version) { should eq('HORSESHOE') }
    end

    describe '#variant' do
      subject { OperatingSystem::Base.new(name: 'CLOUDY_PONY_OS', version: 'HORSESHOE', variant: 'DONKYTAIL') }

      its(:variant) { should eq('DONKYTAIL') }
    end
  end

  describe OperatingSystem::Ubuntu do
    subject { OperatingSystem::Ubuntu.new('penguin-gentoo') }

    its(:name) { should eq('ubuntu') }
    its(:version) { should eq('penguin') }
    its(:variant) { should eq('gentoo') }
    it { should eq OperatingSystem.for('ubuntu', 'penguin-gentoo') }
  end
end
