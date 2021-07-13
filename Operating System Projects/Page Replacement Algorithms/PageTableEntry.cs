public class PageTableEntry
{
    private int memLocation;
    private int dirtyBit;
    private int referenceBit;

    public void setMemLocation(int memLocation)
    {
        this.memLocation = memLocation;
    }

    public int getMemLocation()
    {
        return memLocation;
    }

    public void setDirtyBit(int dirtyBit)
    {
        this.dirtyBit = dirtyBit;
    }

    public int getDirtyBit()
    {
        return dirtyBit;
    }
    public void setReferenceBit(int referenceBit)
    {
        this.referenceBit = referenceBit;
    }

    public int getReferenceBit()
    {
        return referenceBit;
    }
    public PageTableEntry(int memLocation, int dirtyBit)
    {
        this.memLocation = memLocation;
        this.dirtyBit = dirtyBit;
        referenceBit = 0;
    }

    public PageTableEntry(int memLocation, int dirtyBit, int referenceBit)
    {
        this.memLocation = memLocation;
        this.dirtyBit = dirtyBit;
        this.referenceBit = referenceBit;
    }
}
