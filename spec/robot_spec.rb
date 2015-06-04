require_relative '../the_edge_of_mars'

describe TheEdgeOfMars::Robot do
  let(:x) { 2 }
  let(:y) { 2 }
  let(:direction) { "N" }
  let(:robot) { described_class.new(x, y, direction) }

  context "#initialize" do

    subject { robot }

    it "assigns x" do
      expect(subject.x).to eq(x)
    end

    it "assigns y" do
      expect(subject.y).to eq(y)
    end

    it "assigns direction" do
      expect(subject.direction).to eq(direction)
    end
  end

  context "#current_position" do
    subject { robot.current_position }

    it { expect(subject).to eq([robot.x, robot.y]) }
  end

  context "#turn_left" do
    subject { robot.turn_left }

    context "from north" do
      let(:direction) { "N" }

      it "changes to the west" do
        expect { subject }.to change { robot.direction }.from(direction).to("W")
      end
    end

    context "from west" do
      let(:direction) { "W" }

      it "changes to the south" do
        expect { subject }.to change { robot.direction }.from(direction).to("S")
      end
    end

    context "from south" do
      let(:direction) { "S" }

      it "changes to the east" do
        expect { subject }.to change { robot.direction }.from(direction).to("E")
      end
    end

    context "from east" do
      let(:direction) { "E" }

      it "changes to the north" do
        expect { subject }.to change { robot.direction }.from(direction).to("N")
      end
    end
  end

  context "#turn_right" do
    subject { robot.turn_right }

    context "from north" do
      let(:direction) { "N" }

      it "changes to the east" do
        expect { subject }.to change { robot.direction }.from(direction).to("E")
      end
    end

    context "from east" do
      let(:direction) { "E" }

      it "changes to the south" do
        expect { subject }.to change { robot.direction }.from(direction).to("S")
      end
    end

    context "from south" do
      let(:direction) { "S" }

      it "changes to the west" do
        expect { subject }.to change { robot.direction }.from(direction).to("W")
      end
    end

    context "from west" do
      let(:direction) { "W" }

      it "changes to the north" do
        expect { subject }.to change { robot.direction }.from(direction).to("N")
      end
    end
  end

  context "#go_forward" do
    subject { robot.go_forward }

    context "last coordinates" do
      before do
        robot.last_x = -1
        robot.last_y = -1
      end

      it { expect { subject }.to change { robot.last_x }.to(robot.x) }
      it { expect { subject }.to change { robot.last_y }.to(robot.y) }
    end

    context "new coordinates" do
      context "go north" do
        let(:direction) { "N" }

        it { expect { subject }.to change { robot.y }.by(1) }
        it { expect { subject }.not_to change { robot.x } }
      end

      context "go east" do
        let(:direction) { "E" }

        it { expect { subject }.not_to change { robot.y } }
        it { expect { subject }.to change { robot.x }.by(1) }
      end

      context "go south" do
        let(:direction) { "S" }

        it { expect { subject }.to change { robot.y }.by(-1) }
        it { expect { subject }.not_to change { robot.x } }
      end

      context "go west" do
        let(:direction) { "W" }

        it { expect { subject }.not_to change { robot.y } }
        it { expect { subject }.to change { robot.x }.by(-1) }
      end
    end
  end

  context "#looser!" do
    subject { robot.looser! }

    before do
      robot.last_x = 3
      robot.last_y = 4

      subject
    end

    it { expect(robot.lost_x).to eq(robot.last_x) }
    it { expect(robot.lost_y).to eq(robot.last_y) }
  end

  context "#already_lost?" do
    subject { robot.already_lost? }

    context "lost" do
      before do
        robot.lost_x = 3
        robot.lost_y = 4
      end

      it { expect(subject).to eq(true) }
    end

    context "didn't loose" do
      it { expect(subject).to eq(false) }
    end
  end

  context "#out_of_boundaries_of?" do
    let(:mars) { double(end_x: 5, start_x: 0, end_y: 3, start_y: 0) }

    subject { robot.out_of_boundaries_of?(mars) }

    context "within boundaries" do
      let(:x) { mars.start_x + 1 }
      let(:y) { mars.start_y + 1 }

      it { expect(subject).to eq(false) }
    end

    context "behind north edge" do
      let(:x) { 3 }
      let(:y) { mars.end_y + 1 }

      it { expect(subject).to eq(true) }
    end

    context "behind east edge" do
      let(:x) { mars.end_x + 1 }
      let(:y) { 2 }

      it { expect(subject).to eq(true) }
    end

    context "behind south edge" do
      let(:x) { 3 }
      let(:y) { mars.start_y - 1 }

      it { expect(subject).to eq(true) }
    end

    context "behind west edge" do
      let(:x) { mars.start_x - 1 }
      let(:y) { 2 }

      it { expect(subject).to eq(true) }
    end
  end
end
