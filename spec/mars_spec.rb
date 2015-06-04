require_relative '../the_edge_of_mars'

describe TheEdgeOfMars::Mars do
  let(:end_x) { 5 }
  let(:end_y) { 3 }
  let(:mars) { described_class.new(end_x, end_y) }

  context "#initialize" do
    subject { mars }

    it "assigns end_x" do
      expect(subject.end_x).to eq(end_x)
    end

    it "assigns end_y" do
      expect(subject.end_y).to eq(end_y)
    end
  end

  context "#start_x" do
    subject { mars.start_x }

    it { expect(subject).to eq(0) }
  end

  context "#start_y" do
    subject { mars.start_y }

    it { expect(subject).to eq(0) }
  end
end
