///https://www.sojson.com/json2entity.html

public class __header__
{
    /// <summary>
    /// 
    /// </summary>
    public string fileType { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string app { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string doc { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string schema { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string appAuthor { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string appVersion { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string url { get; set; }
}

public class Layers
{
    /// <summary>
    /// 
    /// </summary>
    public string __type { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string identifier { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string type { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int uid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int gridSize { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int guideGridWid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int guideGridHei { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int displayOpacity { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int inactiveOpacity { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool hideInList { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool hideFieldsWhenInactive { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int pxOffsetX { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int pxOffsetY { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int parallaxFactorX { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int parallaxFactorY { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool parallaxScaling { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> requiredTags { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> excludedTags { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> intGridValues { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string autoTilesetDefUid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> autoRuleGroups { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string autoSourceLayerDefUid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string tilesetDefUid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int tilePivotX { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int tilePivotY { get; set; }
}

public class TileRect
{
    /// <summary>
    /// 
    /// </summary>
    public int x { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int y { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int w { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int h { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int tilesetUid { get; set; }
}

public class DefaultOverride
{
    /// <summary>
    /// 
    /// </summary>
    public string id { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<int> params { get; set; }
}

public class FieldDefs
{
    /// <summary>
    /// 
    /// </summary>
    public string identifier { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string __type { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int uid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string type { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool isArray { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool canBeNull { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string arrayMinLength { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string arrayMaxLength { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string editorDisplayMode { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string editorDisplayPos { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool editorAlwaysShow { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool editorCutLongValues { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string editorTextSuffix { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string editorTextPrefix { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool useForSmartColor { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int min { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int max { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string regex { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string acceptFileTypes { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public DefaultOverride defaultOverride { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string textLanguageMode { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool symmetricalRef { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool autoChainRef { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool allowOutOfLevelRef { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string allowedRefs { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> allowedRefTags { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string tilesetUid { get; set; }
}

public class Entities
{
    /// <summary>
    /// 
    /// </summary>
    public string identifier { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int uid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> tags { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int width { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int height { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool resizableX { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool resizableY { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool keepAspectRatio { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int tileOpacity { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public double fillOpacity { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int lineOpacity { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool hollow { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string color { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string renderMode { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool showName { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int tilesetId { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int tileId { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string tileRenderMode { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public TileRect tileRect { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> nineSliceBorders { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int maxCount { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string limitScope { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string limitBehavior { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public double pivotX { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public double pivotY { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<FieldDefs> fieldDefs { get; set; }
}

public class SavedSelections
{
    /// <summary>
    /// 
    /// </summary>
    public List<int> ids { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string mode { get; set; }
}

public class CachedPixelData
{
    /// <summary>
    /// 
    /// </summary>
    public string opaqueTiles { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string averageColors { get; set; }
}

public class Tilesets
{
    /// <summary>
    /// 
    /// </summary>
    public int __cWid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int __cHei { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string identifier { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int uid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string relPath { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string embedAtlas { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int pxWid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int pxHei { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int tileGridSize { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int spacing { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int padding { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> tags { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string tagsSourceEnumUid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> enumTags { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> customData { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<SavedSelections> savedSelections { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public CachedPixelData cachedPixelData { get; set; }
}

public class Values
{
    /// <summary>
    /// 
    /// </summary>
    public string id { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int tileId { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int color { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<int> __tileSrcRect { get; set; }
}

public class Enums
{
    /// <summary>
    /// 
    /// </summary>
    public string identifier { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int uid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<Values> values { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int iconTilesetUid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string externalRelPath { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string externalFileChecksum { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> tags { get; set; }
}

public class Defs
{
    /// <summary>
    /// 
    /// </summary>
    public List<Layers> layers { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<Entities> entities { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<Tilesets> tilesets { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<Enums> enums { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> externalEnums { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> levelFields { get; set; }
}

public class __tile
{
    /// <summary>
    /// 
    /// </summary>
    public int x { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int y { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int w { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int h { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int tilesetUid { get; set; }
}

public class FieldInstances
{
    /// <summary>
    /// 
    /// </summary>
    public string __identifier { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string __value { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string __type { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string __tile { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int defUid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> realEditorValues { get; set; }
}

public class EntityInstances
{
    /// <summary>
    /// 
    /// </summary>
    public string __identifier { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<int> __grid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<double> __pivot { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> __tags { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public __tile __tile { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string __smartColor { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string iid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int width { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int height { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int defUid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<int> px { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<FieldInstances> fieldInstances { get; set; }
}

public class LayerInstances
{
    /// <summary>
    /// 
    /// </summary>
    public string __identifier { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string __type { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int __cWid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int __cHei { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int __gridSize { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int __opacity { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int __pxTotalOffsetX { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int __pxTotalOffsetY { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string __tilesetDefUid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string __tilesetRelPath { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string iid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int levelId { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int layerDefUid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int pxOffsetX { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int pxOffsetY { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool visible { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> optionalRules { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> intGridCsv { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> autoLayerTiles { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int seed { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string overrideTilesetUid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> gridTiles { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<EntityInstances> entityInstances { get; set; }
}

public class __neighbours
{
    /// <summary>
    /// 
    /// </summary>
    public string levelIid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int levelUid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string dir { get; set; }
}

public class Levels
{
    /// <summary>
    /// 
    /// </summary>
    public string identifier { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string iid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int uid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int worldX { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int worldY { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int worldDepth { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int pxWid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int pxHei { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string __bgColor { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string bgColor { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool useAutoIdentifier { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string bgRelPath { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string bgPos { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public double bgPivotX { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public double bgPivotY { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string __smartColor { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string __bgPos { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string externalRelPath { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> fieldInstances { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<LayerInstances> layerInstances { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<__neighbours> __neighbours { get; set; }
}

public class Root
{
    /// <summary>
    /// 
    /// </summary>
    public __header__ __header__ { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string jsonVersion { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int appBuildId { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int nextUid { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string identifierStyle { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string worldLayout { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int worldGridWidth { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int worldGridHeight { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int defaultLevelWidth { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int defaultLevelHeight { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int defaultPivotX { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int defaultPivotY { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int defaultGridSize { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string bgColor { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string defaultLevelBgColor { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool minifyJson { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool externalLevels { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool exportTiled { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool simplifiedExport { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string imageExportMode { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string pngFilePattern { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public bool backupOnSave { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public int backupLimit { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string levelNamePattern { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public string tutorialDesc { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> flags { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public Defs defs { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<Levels> levels { get; set; }
    /// <summary>
    /// 
    /// </summary>
    public List<string> worlds { get; set; }
}
