import 'dart:math';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/level_world.dart';

import '../game.dart';
import '../tile/tile.dart';

class AStarController extends Component with HasGameReference<MGame>, HasWorldReference<LevelWorld> {
  // Heuristic function for A*
  int manhattanDistance(Point<int> a, Point<int> b) {
    return (a.x - b.x).abs() + (a.y - b.y).abs();
  }

  List<Point<int>> reconstructPath(Map<Point<int>, Point<int>> cameFrom, Point<int> current) {
    List<Point<int>> totalPath = [current];

    while (cameFrom.containsKey(current)) {
      current = cameFrom[current]!;
      totalPath.insert(0, current); // Insert at the beginning to reverse the path
    }

    return totalPath;
  }

// A* Pathfinding function
  List<Point<int>> findPathAStar(Point<int> start, Point<int> goal) {
    // Initialize open and closed lists
    Set<Point<int>> openSet = {start};
    Set<Point<int>> closedSet = {};

    // For node n, cameFrom[n] is the node immediately preceding it on the cheapest path from start to n currently known.
    Map<Point<int>, Point<int>> cameFrom = {};

    // For node n, gScore[n] is the cost of the cheapest path from start to n currently known.
    Map<Point<int>, int> gScore = {};

    for (int j = 0; j < world.grid.length; j++) {
      for (int i = 0; i < world.grid[j].length; i++) {
        // Create a Point for the current position
        Point<int> dimetricCoordinates = world.grid[j][i].dimetricCoordinates;

        // Initialize the gScore for this position to infinity
        gScore[dimetricCoordinates] = 1000000000;
      }
    }
    gScore[start] = 0;

    // For node n, fScore[n] := gScore[n] + h(n). fScore[n] represents our current best guess as to how short a path from start to finish can be if it goes through n.
    Map<Point<int>, int> fScore = {};

    for (int j = 0; j < world.grid.length; j++) {
      for (int i = 0; i < world.grid[j].length; i++) {
        // Create a Point for the current position
        Point<int> dimetricCoordinates = world.grid[j][i].dimetricCoordinates;

        // Initialize the gScore for this position to infinity
        fScore[dimetricCoordinates] = 1000000000;
      }
    }
    fScore[start] = manhattanDistance(start, goal);

    while (openSet.isNotEmpty) {
      // Current node in openSet having the lowest fScore[] value
      Point<int> current = openSet.reduce((a, b) => fScore[a]! < fScore[b]! ? a : b);

      if (current == goal) {
        // Reconstruct path
        return reconstructPath(cameFrom, current);
      }

      openSet.remove(current);
      closedSet.add(current);

      // For each neighbor of current
      for (Point<int> neighbor in getNeighbors(current)) {
        if (closedSet.contains(neighbor)) continue; // Ignore the neighbor which is already evaluated.

        // The distance from start to a neighbor
        int tentativeGScore = gScore[current]! + 1;

        if (!openSet.contains(neighbor)) {
          openSet.add(neighbor); // Discovered a new node
        } else if (tentativeGScore >= gScore[neighbor]!) {
          continue; // This is not a better path.
        }

        // This path is the best until now. Record it!
        cameFrom[neighbor] = current;
        gScore[neighbor] = tentativeGScore;
        fScore[neighbor] = gScore[neighbor]! + manhattanDistance(neighbor, goal);
      }
    }

    return []; // Failed to find a path
  }

  List<Point<int>> getNeighbors(Point<int> myDimetricCoordinates) {
    List<Point<int>> validatedNeighborsDimetricPoint = [];
    List<Point<int>> neighborsDimetricPoint = [
      Point(myDimetricCoordinates.x, myDimetricCoordinates.y - 1),
      Point(myDimetricCoordinates.x - 1, myDimetricCoordinates.y),
      Point(myDimetricCoordinates.x, myDimetricCoordinates.y + 1),
      Point(myDimetricCoordinates.x + 1, myDimetricCoordinates.y),
    ];

    for (Point<int> neighborDimetricCoordinates in neighborsDimetricPoint) {
      if (world.gridController.checkIfWithinGridBoundaries(neighborDimetricCoordinates)) {
        Tile me = world.gridController.getRealTileAtDimetricCoordinates(myDimetricCoordinates)!;
        Tile neighbor = world.gridController.getRealTileAtDimetricCoordinates(neighborDimetricCoordinates)!;

        if (me.canTileConnectWithMe(neighbor) && !neighbor.isTileConstructible) {
          validatedNeighborsDimetricPoint.add(neighborDimetricCoordinates);
        }
      }
    }
    return validatedNeighborsDimetricPoint;
  }
}
