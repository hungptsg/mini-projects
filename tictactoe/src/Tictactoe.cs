using GdX;
using Godot;
using System.Linq;

public partial class Tictactoe : TileMapLayer {
  Grid<string> grid;
  Vector2I xCoords = new Vector2I(1, 1);
  Vector2I oCoords = new Vector2I(0, 1);
  bool win = false;

  public override void _Ready() {
    grid = Grid<string>.FromTileMapLayer(this);
    Area2D.InputEvent += _On_InputEvent;
  }


  void _On_InputEvent(Node viewport, InputEvent ipev, long shapeIdx) {
    if (ipev is InputEventMouseButton ipevMouseButton) {
      if (ipevMouseButton.Pressed) {
        var mouseCoords = LocalToMap(ipevMouseButton.Position);
        if (ipevMouseButton.ButtonIndex == MouseButton.Left) {
          grid[mouseCoords].Data = "x";
          SetCell(mouseCoords, 0, xCoords);
          _BotMakeMove();
          _CheckGameEndConditions();
        }
      }
    }
  }

  void _BotMakeMove() {
    foreach (var cell in grid.Flat) {
      if (cell.Data == null) {
        SetCell(cell.Coords, 0, oCoords);
        cell.Data = "o";
        return;
      }
    }
  }

  void _CheckGameEndConditions() {
    foreach (var row in grid.Rows) {
      if (row.All(c => c.Data == "x")) {
        _Win("p1");
        return;
      }
      if (row.All(c => c.Data == "o")) {
        _Win("p2");
        return;
      }
    }

    foreach (var col in grid.Colunms) {
      if (col.All(c => c.Data == "x")) {
        _Win("p1");
        return;
      }
      if (col.All(c => c.Data == "o")) {
        _Win("p2");
        return;
      }
    }
    if (grid[0, 0].Data == "x" && grid[1, 1].Data == "x" && grid[2, 2].Data == "x") {
      _Win("p1");
      return;
    }
    if (grid[0, 2].Data == "x" && grid[1, 1].Data == "x" && grid[2, 0].Data == "x") {
      _Win("p1");
      return;
    }

    if (grid[0, 0].Data == "o" && grid[1, 1].Data == "o" && grid[2, 2].Data == "o") {
      _Win("p2");
      return;
    }
    if (grid[0, 2].Data == "o" && grid[1, 1].Data == "o" && grid[2, 0].Data == "o") {
      _Win("p2");
      return;
    }
  }

  void _Win(string player) {
    Label.Text = player + " won!";
    Area2D.InputPickable = false;
  }





}
