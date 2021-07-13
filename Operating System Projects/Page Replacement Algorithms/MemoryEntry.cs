public class MemoryEntry
{
    private int processNum;
    private int index;

    public void setProcessNum(int processNum)
    {
        this.processNum = processNum;
    }

    public int getProcessNum()
    {
        return processNum;
    }

    public void setIndex(int index)
    {
        this.index = index;
    }

    public int getIndex()
    {
        return index;
    }

    public MemoryEntry(int processNum, int index)
    {
        this.processNum = processNum;
        this.index = index;
    }
}
