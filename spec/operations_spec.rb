require_relative '../the_edge_of_mars'
require 'open3'

describe TheEdgeOfMars::Operations do
  let(:mars) { TheEdgeOfMars::Mars.new(5, 3) }

  context "#final_position" do

    subject { described_class.final_position(mars, robot, instructions) }

    context "scenario 1" do
      let(:mars) { TheEdgeOfMars::Mars.new(5, 3) }
      let(:robot) { TheEdgeOfMars::Robot.new(1, 1, "E") }
      let(:instructions) { ["R", "F", "R", "F", "R", "F", "R", "F"] }

      it "has correct final position" do
        expect { subject }.not_to change { robot.current_position }
      end

      it "has correct final direction" do
        expect { subject }.not_to change { robot.direction }
      end
    end

    context "scenario 2" do
      let(:robot) { TheEdgeOfMars::Robot.new(3, 2, "N") }
      let(:instructions) { ["F", "R", "R", "F", "L", "L", "F", "F", "R", "R", "F", "L", "L"] }

      before { allow(described_class).to receive(:add_lost_coords).and_return(false) }

      it "has correct final direction" do
        expect { subject }.not_to change { robot.direction }
      end

      it "has correct final position" do
        expect { subject }.to change { robot.current_position }.to eq([3, 3])
      end

      it "has been lost" do
        expect { subject }.to change { robot.already_lost? }.to eq(true)
      end
    end

    context "scenario 3 - two robots" do
      context "first robot looses and leaves 'scent'" do
        let(:robot) { TheEdgeOfMars::Robot.new(3, 2, "N") }
        let(:instructions) { ["F", "R", "R", "F", "L", "L", "F", "F", "R", "R", "F", "L", "L"] }

        it "lost" do
          expect { subject }.to change { robot.already_lost? }.to eq(true)
        end

        context "second robot" do
          let(:robot) { TheEdgeOfMars::Robot.new(0, 3, "W") }
          let(:instructions) { ["L", "L", "F", "F", "F", "L", "F", "L", "F", "L"] }

          it "doesn't loose" do
            expect { subject }.not_to change { robot.already_lost? }
          end
        end
      end
    end
  end
end
